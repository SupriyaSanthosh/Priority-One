tableextension 60058 "SalesLine" extends "Sales Line"
{
    fields
    {
        field(60051; "Work Description"; Text[500])
        {
            DataClassification = CustomerContent;
            Caption = 'Work Description';
        }
    }
}