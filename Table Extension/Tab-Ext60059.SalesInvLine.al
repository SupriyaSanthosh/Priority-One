tableextension 60059 "SalesInvLine" extends "Sales Invoice Line"
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