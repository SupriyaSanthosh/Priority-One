pageextension 60053 pageextension60053 extends "Customer List"
{
    layout
    {
        addafter(Name)
        {
            field("Bill-to Customer No."; Rec."Bill-to Customer No.")
            {
                ToolTip = 'Specifies the value of the Bill-to Customer No. field';
                ApplicationArea = All;
            }
        }
    }
}
