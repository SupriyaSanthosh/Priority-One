page 60053 "Time Sheet Header"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Time Sheet Header";
    Caption = 'Time Sheet Header';

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {

                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field';
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
                field("Resource No."; Rec."Resource No.")
                {
                    ToolTip = 'Specifies the value of the Resource No. field';
                    ApplicationArea = All;
                }
                field("Owner User ID"; Rec."Owner User ID")
                {
                    ToolTip = 'Specifies the value of the Owner User ID field';
                    ApplicationArea = All;
                }
                field("Approver User ID"; Rec."Approver User ID")
                {
                    ToolTip = 'Specifies the value of the Approver User ID field';
                    ApplicationArea = All;
                }
                field("Open Exists"; Rec."Open Exists")
                {
                    ToolTip = 'Specifies the value of the Open Exists field';
                    ApplicationArea = All;
                }
                field("Submitted Exists"; Rec."Submitted Exists")
                {
                    ToolTip = 'Specifies the value of the Submitted Exists field';
                    ApplicationArea = All;
                }
                field("Rejected Exists"; Rec."Rejected Exists")
                {
                    ToolTip = 'Specifies the value of the Rejected Exists field';
                    ApplicationArea = All;
                }
                field("Approved Exists"; Rec."Approved Exists")
                {
                    ToolTip = 'Specifies the value of the Approved Exists field';
                    ApplicationArea = All;
                }
                field("Posted Exists"; Rec."Posted Exists")
                {
                    ToolTip = 'Specifies the value of the Posted Exists field';
                    ApplicationArea = All;
                }
                field(Quantity; Rec.Quantity)
                {
                    ToolTip = 'Specifies the value of the Quantity field';
                    ApplicationArea = All;
                }
                field("Posted Quantity"; Rec."Posted Quantity")
                {
                    ToolTip = 'Specifies the value of the Posted Quantity field';
                    ApplicationArea = All;
                }
                field(Comment; Rec.Comment)
                {
                    ToolTip = 'Specifies the value of the Comment field';
                    ApplicationArea = All;
                }
            }
        }

    }

}