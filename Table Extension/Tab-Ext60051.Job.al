tableextension 60051 tableextension60051 extends Job
{
    fields
    {
        field(60051; Frequency; Enum Frequency)
        {
            Caption = 'Frequency';
            DataClassification = CustomerContent;
        }
        field(60052; "Legacy Code"; Code[50])
        {
            Caption = 'Legacy Code';
            DataClassification = CustomerContent;
        }
        field(60053; "Salesperson Code"; Code[50])
        {
            Caption = 'Relationship Manager';
            FieldClass = FlowField;
            CalcFormula = lookup(Customer."Salesperson Code" where("No." = field("Bill-to Customer No.")));
        }
        field(60054; "Invoice Total"; Decimal)
        {
            Caption = 'Invoice Total';
            FieldClass = FlowField;
            CalcFormula = sum("Job Planning Line"."Line Amount" where("Job No." = field("No.")));
        }
        field(60055; "Invoiced Total"; Decimal)
        {
            Caption = 'Invoiced Total';
            FieldClass = FlowField;
            CalcFormula = sum("Job Planning Line Invoice"."Invoiced Amount (LCY)" where("Job No." = field("No.")));
        }
        field(60056; "Next Action Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Next Action Date';
            trigger OnValidate()
            var
                JobPlanningLine: Record "Job Planning Line";
            begin
                if xRec."Next Action Date" <> 0D then begin
                    if not Confirm('Do you want to update the planning line dates?', true) then
                        exit;
                end;
                JobPlanningLine.Reset();
                JobPlanningLine.SetRange("Job No.", Rec."No.");
                if JobPlanningLine.FindSet() then
                    repeat
                        JobPlanningLine.Validate("Planning Date", Rec."Next Action Date");
                        JobPlanningLine.Modify();
                    until JobPlanningLine.next() = 0;

            end;
        }
        field(60057; Customer; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Customer';
            TableRelation = Customer;
            trigger OnValidate()
            var
                CustomerRec: Record Customer;
                CustomerRec2: Record Customer;
            begin
                Clear(CustomerRec);
                if CustomerRec.get(Customer) then begin
                    if CustomerRec."Bill-to Customer No." <> '' then begin
                        Rec.Validate("Bill-to Customer No.", CustomerRec."Bill-to Customer No.");
                        Clear(CustomerRec2);
                        if CustomerRec2.get(CustomerRec."Bill-to Customer No.") then
                            rec."Currency Code" := CustomerRec2."Currency Code";
                    end else begin
                        Rec.Validate("Bill-to Customer No.", CustomerRec."No.");
                        Clear(CustomerRec2);
                        if CustomerRec2.get(CustomerRec."No.") then
                            rec."Currency Code" := CustomerRec2."Currency Code";
                    end;
                end;
            end;

        }
        field(60058; "Last Date Invoiced"; DateTime)
        {
            Caption = 'Last Date Invoiced';
            DataClassification = CustomerContent;
        }
        field(60059; "Work Description"; Text[500])
        {
            DataClassification = ToBeClassified;
            Caption = 'Work Description';
        }

    }
}
