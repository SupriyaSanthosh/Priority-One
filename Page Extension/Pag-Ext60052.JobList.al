pageextension 60052 pageextension60052 extends "Job List"
{
    Caption = 'Matters';

    layout
    {
        addafter(Status)
        {
            field("Invoice Total"; Rec."Invoice Total")
            {
                ApplicationArea = All;
            }
            field("Invoiced Total"; Rec."Invoiced Total")
            {
                ApplicationArea = All;
            }
        }
    }
    actions
    {
        addlast("<Action9>")
        {
            action(RollOverPeriod)
            {
                ApplicationArea = Jobs;
                Caption = 'Roll Over Period';
                Ellipsis = true;
                Image = CopyFromTask;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Copy a job and its job tasks, planning lines, and prices.';

                trigger OnAction()
                var
                    RooOverMaintainance: Page "Rollover Maintainance";
                begin
                    RooOverMaintainance.SetFromJob(Rec);
                    RooOverMaintainance.RunModal;
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
        modify("Create Job &Sales Invoice")
        {
            Visible = false;
        }
        addafter("Create Job &Sales Invoice")
        {
            action("Create Job &Sales Invoice2")
            {
                ApplicationArea = Jobs;
                Caption = 'Create Job &Sales Invoice';
                Image = JobSalesInvoice;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Report "Job Create Sales Invoice2";
                ToolTip = 'Use a batch job to help you create job sales invoices for the involved job planning lines.';
            }
        }
    }
}
