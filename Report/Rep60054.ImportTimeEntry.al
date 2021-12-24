// report 60054 "Import Time Entry"
// {
//     Caption = 'Import Time Entry';
//     ProcessingOnly = true;
//     UsageCategory = ReportsAndAnalysis;
//     ApplicationArea = All;
//     Permissions = tabledata "Sales Invoice Header" = rm;
//     UseRequestPage = false;

//     trigger OnPreReport()
//     begin
//         if UploadIntoStream('Upload Time Entry', '', '', FileName, ReadInstream) then begin
//             if FileName = '' then
//                 Error('Filename cannot be null');
//             SheetName := ExcelBuffer.SelectSheetsNameStream(ReadInstream);
//             if SheetName = '' then
//                 Error('SheetName cannot be empty');
//         end;

//         ExcelBuffer.LOCKTABLE;
//         ExcelBuffer.OpenBookStream(ReadInstream, SheetName);
//         ExcelBuffer.ReadSheet;

//         GetLastRowNo;
//         Clear(Cnt);
//         Windows.Open('Job No : #1######');
//         FOR I := 2 TO TotalRow DO
//             InsertData(I);
//         Windows.Close();

//         ExcelBuffer.DELETEALL;

//         Message('%1 Time Entries are imported', Cnt);
//     end;

//     local procedure GetLastRowNo()
//     begin
//         CLEAR(TotalRow);
//         if ExcelBuffer.FINDLAST then
//             TotalRow := ExcelBuffer."Row No.";
//     end;

//     local procedure InsertData(RowNo: Integer)
//     var
//         TimeSheetHeader: Record "Time Sheet Header";
//         TimesheetLine: Record "Time Sheet Line";
//         TimesheetLine1: Record "Time Sheet Line";
//         TimeSheetLineComment: Record "Time Sheet Comment Line";
//         Job: Record Job;
//         JobTaskLine: Record "Job Task";
//         JobPlanningLine: Record "Job Planning Line";
//         JobPlanningLine1: Record "Job Planning Line";
//         TimeSheetCommentLine1: Record "Time Sheet Comment Line";
//         TimeSheetCommentLineNo: Integer;
//         LineNo: Integer;
//         JobPlanningLineNo: Integer;
//         JobNo: Code[20];
//     begin
//         JobNo := GetValueAtCell(RowNo, 1);

//         //Job Create
//         // if not Job.Get(JobNo) then begin
//         //     Job.Init();
//         //     Job.Validate("No.", JobNo);
//         //     Job.Validate("Bill-to Customer No.", '20000');//Test
//         //     Job.Validate("Person Responsible", GetValueAtCell(RowNo, 5));
//         //     Job.Insert(true);
//         // end;

//         //Job Task Lines
//         // if not JobTaskLine.Get(JobNo, GetValueAtCell(RowNo, 4)) then begin
//         //     JobTaskLine.Init();
//         //     JobTaskLine.Validate("Job No.", JobNo);
//         //     JobTaskLine.Validate("Job Task No.", GetValueAtCell(RowNo, 4));
//         //     JobTaskLine.Description := GetValueAtCell(RowNo, 3);
//         //     JobTaskLine.Insert(true);
//         // end;

//         //Create Job Planning Line
//         // JobPlanningLineNo := 10000;
//         // JobPlanningLine1.SetRange("Job No.", JobNo);
//         // JobPlanningLine1.SetRange("Job Task No.", GetValueAtCell(RowNo, 4));
//         // if JobPlanningLine1.FindLast() then
//         //     JobPlanningLineNo := JobPlanningLineNo + JobPlanningLine1."Line No.";

//         // JobPlanningLine.Init();
//         // JobPlanningLine.Validate("Job No.", JobNo);
//         // JobPlanningLine.Validate("Job Task No.", GetValueAtCell(RowNo, 4));
//         // JobPlanningLine.Validate("Line No.", JobPlanningLineNo);
//         // JobPlanningLine.Validate("Document No.", GetValueAtCell(RowNo, 1));
//         // JobPlanningLine.Validate(Type, JobPlanningLine.Type::Resource);
//         // JobPlanningLine.Validate("No.", GetValueAtCell(RowNo, 5));
//         // JobPlanningLine.Validate(Description, GetValueAtCell(RowNo, 3));
//         // Evaluate(JobPlanningLine.Quantity, GetValueAtCell(RowNo, 14));
//         // JobPlanningLine.Insert(true);


//         if not TimeSheetHeader.Get(JobNo) then begin
//             TimeSheetHeader.Init();
//             TimeSheetHeader."No." := JobNo;
//             Evaluate(TimeSheetHeader."Starting Date", GetValueAtCell(RowNo, 9));
//             TimeSheetHeader.Validate("Resource No.", GetValueAtCell(RowNo, 5));
//             TimeSheetHeader.Insert(true);
//         end;

//         LineNo := 10000;
//         TimesheetLine1.SetRange("Time Sheet No.", JobNo);
//         if TimesheetLine1.FindLast() then
//             LineNo := LineNo + TimesheetLine1."Line No.";

//         TimesheetLine.Init();
//         TimesheetLine.Validate("Time Sheet No.", TimeSheetHeader."No.");
//         TimesheetLine."Line No." := LineNo;
//         TimesheetLine.Validate(Type, TimesheetLine.Type::Job);
//         TimesheetLine.Validate(Description, GetValueAtCell(RowNo, 3));
//         TimesheetLine.Validate("Job No.", JobNo);
//         TimesheetLine.Validate("Job Task No.", GetValueAtCell(RowNo, 4));
//         Evaluate(TimesheetLine.Chargeable, GetValueAtCell(RowNo, 8));
//         Evaluate(TimesheetLine."Time Sheet Starting Date", GetValueAtCell(RowNo, 9));
//         Evaluate(TimesheetLine."Total Quantity", GetValueAtCell(RowNo, 14));
//         TimesheetLine.Insert(true);

//         TimeSheetCommentLineNo := 10000;
//         TimeSheetCommentLine1.SetRange("No.", JobNo);
//         TimeSheetCommentLine1.SetRange("Time Sheet Line No.", LineNo);
//         if TimeSheetCommentLine1.FindLast() then
//             TimeSheetCommentLineNo := TimeSheetCommentLineNo + TimeSheetCommentLine1."Line No.";

//         TimeSheetLineComment.Init();
//         TimeSheetLineComment.Validate("No.", JobNo);
//         TimeSheetLineComment."Time Sheet Line No." := TimesheetLine."Line No.";
//         TimeSheetLineComment."Line No." := TimeSheetCommentLineNo;
//         TimeSheetLineComment.Validate(Comment, GetValueAtCell(RowNo, 7));
//         TimeSheetLineComment.Insert(true);

//         Cnt += 1;
//     end;

//     local procedure GetValueAtCell(RowNo: Integer; ColNo: Integer): Text
//     begin
//         if ExcelBuffer.GET(RowNo, ColNo) then
//             exit(ExcelBuffer."Cell Value as Text");
//     end;

//     var
//         ExcelBuffer: Record "Excel Buffer" temporary;
//         ReadInstream: InStream;
//         FileName: Text;
//         SheetName: Text;
//         TotalRow: Integer;
//         I: Integer;
//         Cnt: Integer;
//         Windows: Dialog;
// }
