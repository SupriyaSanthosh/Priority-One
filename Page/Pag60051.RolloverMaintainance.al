page 60051 "Rollover Maintainance"
{
    Caption = 'Rollover Maintainance';
    PageType = StandardDialog;

    layout
    {
        area(content)
        {
            group("Copy from")
            {
                Caption = 'Copy from';
                field(SourceJobNo1; SourceJobNo1)
                {
                    ApplicationArea = Jobs;
                    Caption = 'Job No. From';
                    TableRelation = Job;
                    ToolTip = 'Specifies the job number.';
                    ShowMandatory = true;

                    trigger OnValidate()
                    begin
                        if (SourceJobNo1 <> '') and not SourceJob.Get(SourceJobNo1) then
                            Error(Text003, SourceJob.TableCaption, SourceJobNo1);
                        // TargetJobDescription := SourceJob.Description;
                        // TargetBillToCustomerNo := SourceJob."Bill-to Customer No.";

                        // FromJobTaskNo := '';
                        // ToJobTaskNo := '';
                    end;
                }
                field(SourceJobNo2; SourceJobNo2)
                {
                    ApplicationArea = Jobs;
                    Caption = 'Job No. To';
                    TableRelation = Job;
                    ToolTip = 'Specifies the job number.';
                    ShowMandatory = true;

                    trigger OnValidate()
                    begin
                        if (SourceJobNo2 <> '') and not SourceJob.Get(SourceJobNo2) then
                            Error(Text003, SourceJob.TableCaption, SourceJobNo2);
                        // TargetJobDescription := SourceJob.Description;
                        // TargetBillToCustomerNo := SourceJob."Bill-to Customer No.";

                        // FromJobTaskNo := '';
                        // ToJobTaskNo := '';
                    end;
                }
                field(Frequency; Frequency)
                {
                    ApplicationArea = Jobs;
                    Caption = 'Frequency';
                    ShowMandatory = true;
                    ToolTip = 'Specifies the Frequency.';
                }
                // field(FromJobTaskNo; FromJobTaskNo)
                // {
                //     ApplicationArea = Jobs;
                //     Caption = 'Job Task No. from';
                //     ToolTip = 'Specifies the first job task number to be copied from. Only planning lines with a job task number equal to or higher than the number specified in this field will be included.';

                //     trigger OnLookup(var Text: Text): Boolean
                //     var
                //         JobTask: Record "Job Task";
                //     begin
                //         if SourceJob."No." <> '' then begin
                //             JobTask.SetRange("Job No.", SourceJob."No.");
                //             if PAGE.RunModal(PAGE::"Job Task List", JobTask) = ACTION::LookupOK then
                //                 FromJobTaskNo := JobTask."Job Task No.";
                //         end;
                //     end;

                //     trigger OnValidate()
                //     var
                //         JobTask: Record "Job Task";
                //     begin
                //         if (FromJobTaskNo <> '') and not JobTask.Get(SourceJob."No.", FromJobTaskNo) then
                //             Error(Text003, JobTask.TableCaption, FromJobTaskNo);
                //     end;
                // }
                // field(ToJobTaskNo; ToJobTaskNo)
                // {
                //     ApplicationArea = Jobs;
                //     Caption = 'Job Task No. to';
                //     ToolTip = 'Specifies the last job task number to be copied from. Only planning lines with a job task number equal to or lower than the number specified in this field will be included.';

                //     trigger OnLookup(var Text: Text): Boolean
                //     var
                //         JobTask: Record "Job Task";
                //     begin
                //         if SourceJobNo <> '' then begin
                //             JobTask.SetRange("Job No.", SourceJobNo);
                //             if PAGE.RunModal(PAGE::"Job Task List", JobTask) = ACTION::LookupOK then
                //                 ToJobTaskNo := JobTask."Job Task No.";
                //         end;
                //     end;

                //     trigger OnValidate()
                //     var
                //         JobTask: Record "Job Task";
                //     begin
                //         if (ToJobTaskNo <> '') and not JobTask.Get(SourceJobNo, ToJobTaskNo) then
                //             Error(Text003, JobTask.TableCaption, ToJobTaskNo);
                //     end;
                // }
                field("From Source"; Source)
                {
                    ApplicationArea = Jobs;
                    Caption = 'Source';
                    OptionCaption = 'Job Planning Lines,Job Ledger Entries,None';
                    ToolTip = 'Specifies the basis on which you want the planning lines to be copied. If, for example, you want the planning lines to reflect actual usage and invoicing of items, resources, and general ledger expenses on the job you copy from, then select Job Ledger Entries in this field.';

                    trigger OnValidate()
                    begin
                        ValidateSource;
                    end;
                }
                field("Planning Line Type"; PlanningLineType)
                {
                    ApplicationArea = Jobs;
                    Caption = 'Incl. Planning Line Type';
                    Enabled = PlanningLineTypeEnable;
                    OptionCaption = 'Budget+Billable,Budget,Billable';
                    ToolTip = 'Specifies how copy planning lines. Budget+Billable: All planning lines are copied. Budget: Only lines of type Budget or type Both Budget and Billable are copied. Billable: Only lines of type Billable or type Both Budget and Billable are copied.';
                }
                field("Ledger Entry Line Type"; LedgerEntryType)
                {
                    ApplicationArea = Jobs;
                    Caption = 'Incl. Ledger Entry Line Type';
                    Enabled = LedgerEntryLineTypeEnable;
                    OptionCaption = 'Usage+Sale,Usage,Sale';
                    ToolTip = 'Specifies how to copy job ledger entries. Usage+Sale: All job ledger entries are copied. Entries of type Usage are copied to new planning lines of type Budget. Entries of type Sale are copied to new planning lines of type Billable. Usage: All job ledger entries of type Usage are copied to new planning lines of type Budget. Sale: All job ledger entries of type Sale are copied to new planning lines of type Billable.';
                }
                // field(FromDate; FromDate)
                // {
                //     ApplicationArea = Jobs;
                //     Caption = 'Starting Date';
                //     ToolTip = 'Specifies the date from which the report or batch job processes information.';
                // }
                // field(ToDate; ToDate)
                // {
                //     ApplicationArea = Jobs;
                //     Caption = 'Ending Date';
                //     ToolTip = 'Specifies the date to which the report or batch job processes information.';
                // }
            }
            // group("Copy to")
            // {
            //     Caption = 'Copy to';
            //     field(TargetJobNo; TargetJobNo)
            //     {
            //         ApplicationArea = Jobs;
            //         Caption = 'Job No.';
            //         ToolTip = 'Specifies the job number.';
            //     }
            //     field(TargetJobDescription; TargetJobDescription)
            //     {
            //         ApplicationArea = Jobs;
            //         Caption = 'Job Description';
            //         ToolTip = 'Specifies a description of the job.';
            //     }
            //     field(TargetBillToCustomerNo; TargetBillToCustomerNo)
            //     {
            //         ApplicationArea = Jobs;
            //         Caption = 'Bill-To Customer No.';
            //         TableRelation = Customer;
            //         ToolTip = 'Specifies the number of an alternate customer that the job is billed to instead of the main customer.';
            //     }
            // }
            group(Apply)
            {
                Caption = 'Apply';
                field(CopyJobPrices; CopyJobPrices)
                {
                    ApplicationArea = Jobs;
                    Caption = 'Copy Job Prices';
                    ToolTip = 'Specifies that item prices, resource prices, and G/L prices will be copied from the job that you specified on the Copy From FastTab.';
                }
                field(CopyQuantity; CopyQuantity)
                {
                    ApplicationArea = Jobs;
                    Caption = 'Copy Quantity';
                    ToolTip = 'Specifies that the quantities will be copied to the new job.';
                }
                field(CopyDimensions; CopyDimensions)
                {
                    ApplicationArea = Dimensions;
                    Caption = 'Copy Dimensions';
                    ToolTip = 'Specifies that the dimensions will be copied to the new job.';
                }
                field(IncludeCategories; IncludeCategories)
                {
                    ApplicationArea = All;
                    Caption = 'Include Categories';
                    ToolTip = 'Specifies that the item categories will be copied to the new job.';
                    TableRelation = "Item Category".Code;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        Frequency := Frequency::Annually;
        PlanningLineType := PlanningLineType::"Budget+Billable";
        LedgerEntryType := LedgerEntryType::"Usage+Sale";
        ValidateSource;
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    var
        ActualSourceJob: Record Job;
        JobsSetup: Record "Jobs Setup";
        NoSeriesManagement: Codeunit NoSeriesManagement;
        Cnt: Integer;
    begin
        if CloseAction in [ACTION::OK, ACTION::LookupOK] then begin
            Clear(Cnt);
            ValidateUserInput;
            JobsSetup.Get();
            JobsSetup.TestField("Job Nos.");

            ActualSourceJob.Reset();
            ActualSourceJob.SetRange("No.", SourceJobNo1, SourceJobNo2);
            if Frequency <> Frequency::" " then
                ActualSourceJob.SetRange(Frequency, Frequency);
            ActualSourceJob.SetFilter(Status, '<>%1', ActualSourceJob.Status::Completed);
            if ActualSourceJob.FindSet() then
                repeat
                    Clear(TargetJobNo);
                    Clear(TargetBillToCustomerNo);
                    TargetJobDescription := ActualSourceJob.Description;
                    // TargetBillToCustomerNo := ActualSourceJob."Bill-to Customer No.";

                    Clear(TargetJobNo);
                    TargetJobNo := NoSeriesManagement.GetNextNo(JobsSetup."Job Nos.", 0D, true);

                    Clear(CopyJob);
                    CopyJob.SetCopyOptions(CopyJobPrices, CopyQuantity, CopyDimensions, Source, PlanningLineType, LedgerEntryType, IncludeCategories);
                    CopyJob.SetJobTaskRange(FromJobTaskNo, ToJobTaskNo);
                    CopyJob.SetJobTaskDateRange(FromDate, ToDate);

                    CopyJob.CopyJob(ActualSourceJob, TargetJobNo, TargetJobDescription, TargetBillToCustomerNo);
                    Cnt += 1;

                    //MQ-SUPRIYA-14-09-2021 >>
                    ActualSourceJob.Validate(Status, ActualSourceJob.Status::Completed);
                    ActualSourceJob.Modify(true);
                //MQ-SUPRIYA-14-09-2021 <<

                until ActualSourceJob.Next() = 0;

            Message('%1 Jobs are created.', Cnt);
            // Message(Text001, SourceJob."No.", TargetJobNo);
        end
    end;

    var
        SourceJob: Record Job;
        CopyJob: Codeunit "Custom Copy Job";
        SourceJobNo1: Code[20];
        SourceJobNo2: Code[20];
        FromJobTaskNo: Code[20];
        ToJobTaskNo: Code[20];
        TargetJobNo: Code[20];
        TargetJobDescription: Text[100];
        TargetBillToCustomerNo: Code[20];
        IncludeCategories: Code[20];
        FromDate: Date;
        ToDate: Date;
        Source: Option "Job Planning Lines","Job Ledger Entries","None";
        PlanningLineType: Option "Budget+Billable",Budget,Billable;
        LedgerEntryType: Option "Usage+Sale",Usage,Sale;
        Frequency: Enum Frequency;
        Text001: Label 'The job no. %1 was successfully copied to the new job no. %2 with the status Planning.', Comment = '%1 - The "No." of source job; %2 - The "No." of target job';
        Text002: Label 'Job No. %1 will be assigned to the new Job. Do you want to continue?';
        Text003: Label '%1 %2 does not exist.', Comment = 'Job Task 1000 does not exist.';
        CopyJobPrices: Boolean;
        CopyQuantity: Boolean;
        CopyDimensions: Boolean;
        [InDataSet]
        PlanningLineTypeEnable: Boolean;
        [InDataSet]
        LedgerEntryLineTypeEnable: Boolean;
        Text004: Label 'Provide a valid source %1.';

    local procedure ValidateUserInput()
    var
        JobsSetup: Record "Jobs Setup";
        NoSeriesManagement: Codeunit NoSeriesManagement;
    begin
        if (SourceJobNo1 = '') or not SourceJob.Get(SourceJobNo1) then
            Error(Text004, SourceJob.TableCaption);

        if (SourceJobNo2 = '') or not SourceJob.Get(SourceJobNo2) then
            Error(Text004, SourceJob.TableCaption);

        if Frequency = Frequency::" " then
            Error('Provide a valid Frequency.');
        // JobsSetup.Get();
        // JobsSetup.TestField("Job Nos.");
        // if TargetJobNo = '' then begin
        //     TargetJobNo := NoSeriesManagement.GetNextNo(JobsSetup."Job Nos.", 0D, true);
        //     if not Confirm(Text002, true, TargetJobNo) then begin
        //         TargetJobNo := '';
        //         Error('');
        //     end;
        // end else
        //     NoSeriesManagement.TestManual(JobsSetup."Job Nos.");
    end;

    local procedure ValidateSource()
    begin
        case true of
            Source = Source::"Job Planning Lines":
                begin
                    PlanningLineTypeEnable := true;
                    LedgerEntryLineTypeEnable := false;
                end;
            Source = Source::"Job Ledger Entries":
                begin
                    PlanningLineTypeEnable := false;
                    LedgerEntryLineTypeEnable := true;
                end;
            Source = Source::None:
                begin
                    PlanningLineTypeEnable := false;
                    LedgerEntryLineTypeEnable := false;
                end;
        end;
    end;

    procedure SetFromJob(SourceJob2: Record Job)
    begin
        SourceJob := SourceJob2;
        SourceJobNo1 := SourceJob."No.";
        SourceJobNo2 := SourceJob."No.";
        // TargetJobDescription := SourceJob.Description;
        // TargetBillToCustomerNo := SourceJob."Bill-to Customer No.";
    end;
}

