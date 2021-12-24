tableextension 60056 tableextension60056 extends "Job Task"
{
    fields
    {
        field(60051; Frequency; Enum Frequency)
        {
            Caption = 'Frequency';
            FieldClass = FlowField;
            CalcFormula = lookup(job.Frequency where("No." = field("Job No.")));
        }
    }
}
