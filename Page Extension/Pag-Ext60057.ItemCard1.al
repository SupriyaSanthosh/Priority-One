pageextension 60057 "Item Card1" extends "Item Card"
{
    layout
    {
        addlast(Item)
        {

            field("Recurring Services"; Rec."Recurring Services")
            {
                ToolTip = 'Specifies the value of the Recurring Services field';
                ApplicationArea = All;
            }
        }
    }
}