pageextension 60051 pageextension60051 extends "Job Card"
{
    Caption = 'Matter Card';

    layout
    {
        addlast(Duration)
        {
            field(Frequency; Rec.Frequency)
            {
                ApplicationArea = All;
            }
        }
        addlast(General)
        {
            field("Legacy Code"; Rec."Legacy Code")
            {
                ApplicationArea = All;
            }
        }
    }
}
