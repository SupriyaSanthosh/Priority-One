codeunit 60052 EventSubscriber
{
    SingleInstance = true;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Job Create-Invoice", 'OnBeforeModifySalesHeader', '', false, false)]
    local procedure UpdateDescriptionOnSalesHeader(Job: Record Job; var SalesHeader: Record "Sales Header")
    begin
        SalesHeader.SetWorkDescription(Job."Work Description");
    end;


    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterDeleteEvent', '', false, false)]
    local procedure clearCompleteflag(var Rec: Record "Sales Line")
    var
        JobPlanningLine: Record "Job Planning Line";
    begin
        if IsDeleteFromPost then
            exit;

        JobPlanningLine.SetRange("Job No.", Rec."Job No.");
        JobPlanningLine.SetRange("Job Task No.", Rec."Job Task No.");
        JobPlanningLine.SetRange(Quantity, Rec.Quantity);
        JobPlanningLine.SetRange("No.", Rec."No.");
        //JobPlanningLine.SetRange(Type, JobPlanningLine.Type::"G/L Account");
        if JobPlanningLine.FindSet() then begin
            repeat
                JobPlanningLine.Complete := false;
                JobPlanningLine.Modify(true);
            until JobPlanningLine.Next() = 0;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforeReleaseSalesDocument', '', false, false)]
    local procedure OnBeforeReleaseSalesDocument()
    begin
        IsDeleteFromPost := true;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterPostSalesDoc', '', false, false)]
    local procedure UpdateLastDateInvoiced(var SalesHeader: Record "Sales Header")
    var
        Job: Record Job;
        JobPlanningLineInvoice: Record "Job Planning Line Invoice";
    begin
        IsDeleteFromPost := false;
        JobPlanningLineInvoice.SetRange("Document Type", JobPlanningLineInvoice."Document Type"::Invoice);
        JobPlanningLineInvoice.SetRange("Document No.", SalesHeader."No.");
        if JobPlanningLineInvoice.FindFirst() then
            if Job.Get(JobPlanningLineInvoice."Job No.") then begin
                Job."Last Date Invoiced" := CurrentDateTime;
                Job.Modify(true);
            end;
    end;

    var
        IsDeleteFromPost: Boolean;
}