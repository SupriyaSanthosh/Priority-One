tableextension 60054 Customer extends Customer
{
    fields
    {
        field(60051; Trustee; Code[20])
        {
            Caption = 'Trustee';
            DataClassification = CustomerContent;
            TableRelation = Contact;
        }
    }
}
