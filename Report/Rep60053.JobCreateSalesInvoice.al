report 60053 "Job Create Sales Invoice2"
{
    ApplicationArea = Jobs;
    Caption = 'Job Create Sales Invoice';
    ProcessingOnly = true;
    UsageCategory = Tasks;

    dataset
    {
        dataitem("Job Task"; "Job Task")
        {
            DataItemTableView = SORTING("Job No.", "Job Task No.");
            RequestFilterFields = "Job No.", "Job Task No.", "Planning Date Filter";

            trigger OnAfterGetRecord()
            var
                Job: Record Job;
                JobPlanningLine: Record "Job Planning Line";
                IsHandled: Boolean;
                ItemRec: Record Item;
            begin
                IsHandled := false;
                OnBeforeJobTaskOnAfterGetRecord("Job Task", IsHandled);
                if not IsHandled then
                    JobCreateInvoice.CreateSalesInvoiceJobTask(
                      "Job Task", PostingDate, InvoicePerTask, NoOfInvoices, OldJobNo, OldJTNo, false);

                Job.Get("Job Task"."Job No.");
                JobPlanningLine.SetRange("Job No.", "Job Task"."Job No.");
                JobPlanningLine.SetRange("Job Task No.", "Job Task"."Job Task No.");
                if JobPlanningLine.FindSet() then
                    repeat
                        if JobPlanningLine.Type <> JobPlanningLine.Type::Item then begin
                            JobPlanningLine.Complete := true;
                        end else begin
                            ItemRec.Reset();
                            if ItemRec.Get(JobPlanningLine."No.") then begin
                                if (not ItemRec."Recurring Services") or (ItemRec.Type <> ItemRec.Type::Inventory) then begin
                                    JobPlanningLine.Complete := true;
                                end;
                            end;
                        end;
                        JobPlanningLine.Validate("Planning Date", Job."Next Action Date");
                        JobPlanningLine.Modify(true);
                    until JobPlanningLine.Next() = 0;

                if Job.Frequency = Job.Frequency::Annually then
                    Job."Next Action Date" := CalcDate('<+1Y>', Job."Next Action Date");

                if Job.Frequency = Job.Frequency::Monthly then
                    Job."Next Action Date" := CalcDate('<+1M>', Job."Next Action Date");

                if Job.Frequency = Job.Frequency::Quaterly then
                    Job."Next Action Date" := CalcDate('<+3M>', Job."Next Action Date");
                Job.Modify(true);
            end;

            trigger OnPostDataItem()
            begin
                JobCreateInvoice.CreateSalesInvoiceJobTask(
                  "Job Task", PostingDate, InvoicePerTask, NoOfInvoices, OldJobNo, OldJTNo, true);
            end;

            trigger OnPreDataItem()
            begin
                NoOfInvoices := 0;
                OldJobNo := '';
                OldJTNo := '';
                if gFrequency <> gFrequency::" " then
                    "Job Task".SetRange(Frequency, gFrequency);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(PostingDate; PostingDate)
                    {
                        ApplicationArea = Jobs;
                        Caption = 'Posting Date';
                        ToolTip = 'Specifies the posting date for the document.';
                    }
                    field(JobChoice; JobChoice)
                    {
                        ApplicationArea = Jobs;
                        Caption = 'Create Invoice per';
                        OptionCaption = 'Job,Job Task';
                        ToolTip = 'Specifies, if you select the Job Task option, that you want to create one invoice per job task rather than the one invoice per job that is created by default.';
                    }
                    field(Frequency; gFrequency)
                    {
                        ApplicationArea = Jobs;
                        Caption = 'Frequency';
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            PostingDate := WorkDate;
        end;
    }

    labels
    {
    }

    trigger OnPostReport()
    begin
        OnBeforePostReport;

        JobCalcBatches.EndCreateInvoice(NoOfInvoices);

        OnAfterPostReport(NoOfInvoices);
    end;

    trigger OnPreReport()
    begin
        if PostingDate = 0D then
            PostingDate := WorkDate();
        JobCalcBatches.BatchError(PostingDate, Text000);
        InvoicePerTask := JobChoice = JobChoice::"Job Task";
        JobCreateInvoice.DeleteSalesInvoiceBuffer;

        OnAfterPreReport;
    end;

    var
        JobCreateInvoice: Codeunit "Job Create-Invoice";
        JobCalcBatches: Codeunit "Job Calculate Batches";
        PostingDate: Date;
        NoOfInvoices: Integer;
        InvoicePerTask: Boolean;
        JobChoice: Option Job,"Job Task";
        OldJobNo: Code[20];
        OldJTNo: Code[20];
        Text000: Label 'A', Comment = 'A';
        gFrequency: Enum Frequency;

    [IntegrationEvent(false, false)]
    local procedure OnAfterPostReport(NoOfInvoices: Integer)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterPreReport()
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeJobTaskOnAfterGetRecord(JobTask: Record "Job Task"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforePostReport()
    begin
    end;
}

