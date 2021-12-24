tableextension 60055 Resource extends Resource
{
    fields
    {
        field(60051; Email; Text[250])
        {
            Caption = 'Email';
            DataClassification = CustomerContent;
            trigger OnValidate()
            var
                EmailAccount: Codeunit "Email Account";
            begin
                EmailAccount.ValidateEmailAddress(Rec.Email);
            end;
        }
    }
}
