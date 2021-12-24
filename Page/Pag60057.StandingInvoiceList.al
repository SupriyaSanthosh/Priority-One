page 60057 "Standing Invoices"
{
    Caption = 'Standing Invoices';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = Job;
    Editable = false;
    CardPageId = "Standing Invoice";

    layout
    {
        area(Content)
        {
            repeater(StandingInvoicesList)
            {

                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field';
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field';
                    ApplicationArea = All;
                }
                field("Description 2"; Rec."Description 2")
                {
                    ToolTip = 'Specifies the value of the Description 2 field';
                    ApplicationArea = All;
                }
                field("Bill-to Customer No."; Rec."Bill-to Customer No.")
                {
                    ToolTip = 'Specifies the value of the Bill-to Customer No. field';
                    ApplicationArea = All;
                }
                field("Bill-to Name"; Rec."Bill-to Name")
                {
                    ToolTip = 'Specifies the value of the Bill-to Name field';
                    ApplicationArea = All;
                }
                field(SalesPersonName; SalesPerson.Name)
                {
                    ToolTip = 'Specifies the value of the Bill-to Name';
                    Caption = 'Relationship Manager';
                    ApplicationArea = All;
                }
                field("Starting Date"; Rec."Starting Date")
                {
                    ToolTip = 'Specifies the value of the Starting Date field';
                    ApplicationArea = All;
                }
                field("Ending Date"; Rec."Ending Date")
                {
                    ToolTip = 'Specifies the value of the Ending Date field';
                    ApplicationArea = All;
                }
                field("Next Action Date"; Rec."Next Action Date")
                {
                    ToolTip = 'Specifies the value of the Next Action Date field';
                    ApplicationArea = All;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ToolTip = 'Specifies the value of the Currency Code field';
                    ApplicationArea = All;
                }

                field("Invoiced Total"; Rec."Invoiced Total")
                {
                    ToolTip = 'Specifies the value of the Invoiced Total field';
                    ApplicationArea = All;
                }
                field("Invoice Total"; Rec."Invoice Total")
                {
                    ToolTip = 'Specifies the value of the Invoice Total field';
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field';
                    ApplicationArea = All;
                }

                field("Person Responsible"; Rec."Person Responsible")
                {
                    ToolTip = 'Specifies the value of the Person Responsible field';
                    ApplicationArea = All;
                }
                field("Job Posting Group"; Rec."Job Posting Group")
                {
                    ToolTip = 'Specifies the value of the Job Posting Group field';
                    ApplicationArea = All;
                }
                field(Blocked; Rec.Blocked)
                {
                    ToolTip = 'Specifies the value of the Blocked field';
                    ApplicationArea = All;
                }
                field("Creation Date"; Rec."Creation Date")
                {
                    ToolTip = 'Specifies the value of the Creation Date field';
                    ApplicationArea = All;
                }



            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Create Invoice")
            {
                ApplicationArea = Jobs;
                Caption = 'Create Invoice';
                Image = JobSalesInvoice;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Use a batch job to help you create job sales invoices for the involved job planning lines.';

                trigger OnAction()
                var
                    Job: Record Job;
                    JobPlanningLine: record "Job Planning Line";
                    Item: Record Item;
                    JobNumbers: Text;

                begin
                    CurrPage.SetSelectionFilter(Rec);
                    if Rec.FindSet() then
                        repeat
                            if JobNumbers <> '' then
                                JobNumbers := JobNumbers + '|' + Rec."No."
                            else
                                JobNumbers := Rec."No.";
                        until Rec.Next() = 0;
                    Rec.Reset();
                    if JobNumbers <> '' then begin
                        Job.SetFilter("No.", JobNumbers);
                        if Job.FindSet() then begin
                            repeat
                                // JobPlanningLine.Reset();
                                // JobPlanningLine.SetRange("Job No.", Job."No.");
                                // JobPlanningLine.SetRange(Complete, false);
                                // if JobPlanningLine.FindSet() then
                                //     repeat
                                //         if JobPlanningLine.Type <> JobPlanningLine.Type::Item then begin
                                //             JobPlanningLine.Complete := true;
                                //             JobPlanningLine.Modify(true);
                                //         end
                                //         else begin
                                //             Item.Get(JobPlanningLine."Item No.");
                                //             if (Not Item."Recurring Services") or (Item.Type <> Item.Type::Inventory) then begin
                                //                 JobPlanningLine.Complete := true;
                                //                 JobPlanningLine.Modify(true);
                                //             end;
                                //         end;
                                //     until JobPlanningLine.Next() = 0;

                                CreateSalesInvoices(Job);

                                if Job.Frequency = Job.Frequency::Annually then
                                    Job."Next Action Date" := CalcDate('<+1Y>', Job."Next Action Date");

                                if Job.Frequency = Job.Frequency::Monthly then
                                    Job."Next Action Date" := CalcDate('<+1M>', Job."Next Action Date");

                                if Job.Frequency = Job.Frequency::Quaterly then
                                    Job."Next Action Date" := CalcDate('<+3M>', Job."Next Action Date");
                                Job.Modify(true);

                                JobPlanningLine.Reset();
                                JobPlanningLine.SetRange("Job No.", Job."No.");
                                if JobPlanningLine.FindSet() then
                                    repeat
                                        if JobPlanningLine.Type <> JobPlanningLine.Type::Item then
                                            JobPlanningLine.Complete := true
                                        else
                                            if Item.Get(JobPlanningLine."Item No.") then
                                                if (Not Item."Recurring Services") or (Item.Type <> Item.Type::Inventory) then
                                                    JobPlanningLine.Complete := true;
                                        JobPlanningLine."Planning Date" := Job."Next Action Date";
                                        JobPlanningLine.Modify();
                                    until JobPlanningLine.next() = 0;

                            until Job.Next() = 0;
                        end;
                        Message('Sales Invoice has been created.');
                    end;
                    CurrPage.Update();
                end;
            }
            action("Create Job &Sales Invoice2")
            {
                ApplicationArea = Jobs;
                Caption = 'Create Job &Sales Invoice';
                Image = JobSalesInvoice;
                Promoted = true;
                Visible = false;
                PromotedCategory = Process;
                // RunObject = Report "Job Create Sales Invoice2";
                ToolTip = 'Use a batch job to help you create job sales invoices for the involved job planning lines.';

                trigger OnAction()
                var
                    JobTask: Record "Job Task";
                    JobNumbers: Text;
                begin
                    CurrPage.SetSelectionFilter(Rec);
                    if Rec.FindSet() then
                        repeat
                            if JobNumbers <> '' then
                                JobNumbers := JobNumbers + '|' + Rec."No."
                            else
                                JobNumbers := Rec."No.";
                        until Rec.Next() = 0;
                    Rec.Reset();

                    JobTask.SetFilter("Job No.", JobNumbers);
                    If JobTask.FindSet() then
                        Report.RunModal(Report::"Job Create Sales Invoice2", false, false, JobTask);
                end;
            }

            action(SendForApproval)
            {
                ApplicationArea = Jobs;
                Caption = 'Send for Approval';
                Ellipsis = true;
                Image = Report;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    Job: Record Job;
                begin
                    Clear(Job);
                    CurrPage.SetSelectionFilter(Job);
                    Report.RunModal(Report::"Create Invoice Approval", false, false, Job);
                end;
            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        If SalesPerson.Get("Salesperson Code") then;
    end;

    var
        myInt: Integer;
        SalesPerson: Record "Salesperson/Purchaser";


    local procedure CreateSalesInvoices(Var _Job: Record Job)
    var
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        JobPlanningLine: Record "Job Planning Line";
        JobPlanningLineInvoice: Record "Job Planning Line Invoice";
        ItemRec: Record Item;
        GetNextNo: Codeunit NoSeriesManagement;
        LineNo: Integer;
    begin
        if _Job.Blocked <> _Job.Blocked::" " then
            error('Invoice cannot be created because Job is blocked.');
        SalesHeader.Reset();
        SalesHeader.Init();
        SalesHeader.Validate("Document Type", SalesHeader."Document Type"::Invoice);
        //SalesHeader.Validate("No.",GetNextNo());
        SalesHeader.Insert(true);
        SalesHeader.Validate("Sell-to Customer No.", _Job.Customer);
        SalesHeader.Validate("Bill-to Customer No.", _job."Bill-to Customer No.");
        SalesHeader.Validate("Posting Date", _Job."Next Action Date");
        SalesHeader.Validate("Currency Code", _job."Currency Code");
        SalesHeader.SetWorkDescription(_Job."Work Description"); //Supriya
        SalesHeader.Modify();
        _Job."Last Date Invoiced" := CurrentDateTime;
        LineNo := 0;
        JobPlanningLine.Reset();
        JobPlanningLine.SetCurrentKey("Line No.");
        JobPlanningLine.SetRange("Job No.", _Job."No.");
        JobPlanningLine.SetFilter(Quantity, '<>%1', 0);
        JobPlanningLine.SetRange(Complete, false);
        if JobPlanningLine.FindSet() then begin
            repeat
                LineNo += 10000;
                SalesLine.Init();
                SalesLine.validate("Document Type", SalesLine."Document Type"::invoice);
                SalesLine.validate("Document No.", SalesHeader."No.");
                SalesLine.Validate("Line No.", LineNo);
                SalesLine.Insert();
                if JobPlanningLine.Type = JobPlanningLine.Type::Resource then
                    SalesLine.Validate(Type, SalesLine.Type::Resource);
                if JobPlanningLine.Type = JobPlanningLine.Type::Item then
                    SalesLine.Validate(Type, SalesLine.Type::Item);
                if JobPlanningLine.Type = JobPlanningLine.Type::"G/L Account" then
                    SalesLine.Validate(Type, SalesLine.Type::"G/L Account");
                SalesLine.Validate("No.", JobPlanningLine."No.");
                SalesLine.Description := COPYSTR(JobPlanningLine."Work description", 1, 95);
                SalesLine.Validate("Job No.", JobPlanningLine."Job No.");
                SalesLine.Validate("Job Task No.", JobPlanningLine."Job Task No.");
                SalesLine.Validate(Quantity, JobPlanningLine.Quantity);
                SalesLine.Validate("Unit of Measure Code", JobPlanningLine."Unit of Measure Code");
                SalesLine.Validate("Unit Price", JobPlanningLine."Unit Price");
                SalesLine.Description := COPYSTR(JobPlanningLine."Work description", 1, 95);
                SalesLine."Work Description" := JobPlanningLine."Work description";

                SalesLine.Modify();

                JobPlanningLineInvoice."Job No." := JobPlanningLine."Job No.";
                JobPlanningLineInvoice."Job Task No." := JobPlanningLine."Job Task No.";
                JobPlanningLineInvoice."Job Planning Line No." := JobPlanningLine."Line No.";
                if SalesHeader."Document Type" = SalesHeader."Document Type"::Invoice then
                    JobPlanningLineInvoice."Document Type" := JobPlanningLineInvoice."Document Type"::Invoice;
                if SalesHeader."Document Type" = SalesHeader."Document Type"::"Credit Memo" then
                    JobPlanningLineInvoice."Document Type" := JobPlanningLineInvoice."Document Type"::"Credit Memo";
                JobPlanningLineInvoice."Document No." := SalesHeader."No.";
                JobPlanningLineInvoice."Line No." := SalesLine."Line No.";
                JobPlanningLineInvoice."Quantity Transferred" := JobPlanningLine."Qty. to Transfer to Invoice";
                JobPlanningLineInvoice."Transferred Date" := _Job."Next Action Date";


                JobPlanningLineInvoice.Insert();

                if JobPlanningLine.Type <> JobPlanningLine.Type::Item then begin
                    JobPlanningLine.Complete := true;
                    JobPlanningLine.Modify();
                end else begin
                    ItemRec.Reset();
                    if ItemRec.Get(JobPlanningLine."No.") then begin
                        if (not ItemRec."Recurring Services") or (ItemRec.Type <> ItemRec.Type::Inventory) then begin
                            JobPlanningLine.Complete := true;
                            JobPlanningLine.Modify();
                        end;
                    end;
                end;
            until JobPlanningLine.next() = 0;
        end;
    end;
}