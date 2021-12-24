page 60054 "Time Sheet Line"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Time Sheet Line";
    Caption = 'Time Sheet Line';

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {

                field("Time Sheet No."; Rec."Time Sheet No.")
                {
                    ToolTip = 'Specifies the value of the Time Sheet No. field';
                    ApplicationArea = All;
                }
                field("Line No."; Rec."Line No.")
                {
                    ToolTip = 'Specifies the value of the Line No. field';
                    ApplicationArea = All;
                }
                field("Time Sheet Starting Date"; Rec."Time Sheet Starting Date")
                {
                    ToolTip = 'Specifies the value of the Time Sheet Starting Date field';
                    ApplicationArea = All;
                }
                field("Job No."; Rec."Job No.")
                {
                    ToolTip = 'Specifies the value of the Job No. field';
                    ApplicationArea = All;
                }
                field("Type"; Rec."Type")
                {
                    ToolTip = 'Specifies the value of the Type field';
                    ApplicationArea = All;
                }
                field("Job Task No."; Rec."Job Task No.")
                {
                    ToolTip = 'Specifies the value of the Job Task No. field';
                    ApplicationArea = All;
                }
                field("Cause of Absence Code"; Rec."Cause of Absence Code")
                {
                    ToolTip = 'Specifies the value of the Cause of Absence Code field';
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field';
                    ApplicationArea = All;
                }
                field("Work Type Code"; Rec."Work Type Code")
                {
                    ToolTip = 'Specifies the value of the Work Type Code field';
                    ApplicationArea = All;
                }
                field("Approver ID"; Rec."Approver ID")
                {
                    ToolTip = 'Specifies the value of the Approver ID field';
                    ApplicationArea = All;
                }
                field("Service Order No."; Rec."Service Order No.")
                {
                    ToolTip = 'Specifies the value of the Service Order No. field';
                    ApplicationArea = All;
                }
                field("Service Order Line No."; Rec."Service Order Line No.")
                {
                    ToolTip = 'Specifies the value of the Service Order Line No. field';
                    ApplicationArea = All;
                }
                field("Total Quantity"; Rec."Total Quantity")
                {
                    ToolTip = 'Specifies the value of the Total Quantity field';
                    ApplicationArea = All;
                }
                field(Chargeable; Rec.Chargeable)
                {
                    ToolTip = 'Specifies the value of the Chargeable field';
                    ApplicationArea = All;
                }
            }
        }

    }
}