tableextension 60053 JobLedgerEntry extends "Job Ledger Entry"
{
    fields
    {
        field(60051; "Item Category Code"; Code[50])
        {
            Caption = 'Item Category Code';
            FieldClass = FlowField;
            CalcFormula = lookup(Item."Item Category Code" where("No." = field("No.")));
        }
    }
}
