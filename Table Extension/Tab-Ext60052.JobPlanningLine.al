tableextension 60052 tableextension60052 extends "Job Planning Line"
{
    fields
    {
        field(60051; "Item Category Code"; Code[50])
        {
            Caption = 'Item Category Code';
            FieldClass = FlowField;
            CalcFormula = lookup(Item."Item Category Code" where("No." = field("No.")));
        }
        field(60052; "Item No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Job Task No.';
            TableRelation = Item;// where("Recurring Services" = filter(true));

            trigger OnValidate()
            var
                Job: Record Job;
                JobTask: Record "Job Task";
                Item: Record Item;
            begin
                Item.Get(Rec."Item No.");
                Job.Get("Job No.");
                if Not JobTask.Get(Job."No.", Rec."Item No.") then begin
                    JobTask.Init();
                    JobTask.Validate("Job No.", Job."No.");
                    JobTask.Validate("Job Task No.", Rec."Item No.");
                    JobTask.Validate(Description, Item.Description);
                    JobTask.Insert(true);
                end;
                "Job No." := Job."No.";
                "Job Task No." := JobTask."Job Task No.";
                Type := Type::Item;
                //Validate("Line Type", "Line Type"::"Both Budget and Billable");///05102021
                Validate("Line Type", "Line Type"::Budget);///05102021
                Validate("No.", "Item No.");
                Validate("Planning Date", Job."Next Action Date");///
                "Work description" := Rec.Description;
                // if (Not Item."Recurring Services") or (Item.Type <> Item.Type::Inventory) then
                // Complete := true;
            end;
        }
        field(60053; Complete; Boolean)
        {
            Caption = 'Complete';
        }
        field(60054; "Work description"; Text[500])
        {
            DataClassification = CustomerContent;
            Caption = 'Work description';
        }
    }
}
