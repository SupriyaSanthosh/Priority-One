pageextension 60054 pageextension60054 extends "Customer Card"
{
    layout
    {
        addlast(General)
        {
            field(Trustee; Rec.Trustee)
            {
                ToolTip = 'Specifies the value of the Trustee';
                ApplicationArea = All;
            }
        }
    }
}
