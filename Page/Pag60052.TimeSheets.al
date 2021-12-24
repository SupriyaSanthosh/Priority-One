// page 60052 "Time Sheets"
// {
//     PageType = List;
//     ApplicationArea = All;
//     UsageCategory = Lists;
//     SourceTable = "Time Sheet Line";
//     Editable = false;
//     InsertAllowed = false;
//     DeleteAllowed = false;
//     ModifyAllowed = false;

//     layout
//     {
//         area(Content)
//         {
//             repeater(GroupName)
//             {
//                 field("No."; TimeSheetHeader."No.")
//                 {
//                     ToolTip = 'Specifies the value of the No. field';
//                     ApplicationArea = All;
//                     Caption = 'Time Sheet No';
//                 }
//                 field("Resource No."; TimeSheetHeader."Resource No.")
//                 {
//                     ToolTip = 'Specifies the value of the Resource No. field';
//                     ApplicationArea = All;
//                     Caption = 'Resource No.';
//                 }

//                 field(ResourceName; Resource.Name)
//                 {
//                     Caption = 'Resource Name';
//                     ApplicationArea = All;
//                 }
//                 field("Line No."; Rec."Line No.")
//                 {
//                     ToolTip = 'Specifies the value of the Line No. field';
//                     ApplicationArea = All;
//                     Caption = 'Line No.';
//                 }
//                 field("Time Sheet Starting Date"; Rec."Time Sheet Starting Date")
//                 {
//                     ToolTip = 'Specifies the value of the Time Sheet Starting Date field';
//                     ApplicationArea = All;
//                     Caption = 'Date';
//                 }
//                 field("Type"; Rec."Type")
//                 {
//                     ToolTip = 'Specifies the value of the Type field';
//                     ApplicationArea = All;
//                     Caption = 'Type';
//                 }
//                 field("Job No."; Rec."Job No.")
//                 {
//                     ToolTip = 'Specifies the value of the Job No. field';
//                     ApplicationArea = All;
//                     Caption = 'Matter No.';
//                 }
//                 field("Job Task No."; Rec."Job Task No.")
//                 {
//                     ToolTip = 'Specifies the value of the Job Task No. field';
//                     ApplicationArea = All;
//                     Caption = 'Matter Task No. ';
//                 }
//                 field(Description; Rec.Description)
//                 {
//                     ToolTip = 'Specifies the value of the Description field';
//                     ApplicationArea = All;
//                     Caption = 'Description';
//                 }
//                 field("Work Type Code"; Rec."Work Type Code")
//                 {
//                     ToolTip = 'Specifies the value of the Work Type Code field';
//                     ApplicationArea = All;
//                     Caption = 'Work Type Code';
//                 }
//                 field("Total Quantity"; Rec."Total Quantity")
//                 {
//                     ToolTip = 'Specifies the value of the Total Quantity field';
//                     ApplicationArea = All;
//                     Caption = 'Total Quantity';
//                 }
//                 field(Chargeable; Rec.Chargeable)
//                 {
//                     ToolTip = 'Specifies the value of the Chargeable field';
//                     ApplicationArea = All;
//                     Caption = 'Chargeable';
//                 }
//                 field(Status; Rec.Status)
//                 {
//                     ToolTip = 'Specifies the value of the Status field';
//                     ApplicationArea = All;
//                     Caption = 'Status';
//                 }
//                 field(Comment; TimeSheetCommentLine.Comment)
//                 {
//                     ToolTip = 'Specifies the value of the Comment field';
//                     ApplicationArea = All;
//                     Caption = 'Comment';
//                 }
//             }
//         }
//     }

//     actions
//     {
//         area(Processing)
//         {
//             action(EditTimeSheet)
//             {
//                 ApplicationArea = Jobs;
//                 Caption = '&Edit Time Sheet';
//                 Image = OpenJournal;
//                 Promoted = true;
//                 PromotedCategory = Process;
//                 PromotedIsBig = true;
//                 PromotedOnly = true;
//                 ShortCutKey = 'Return';
//                 ToolTip = 'Open the time sheet in edit mode.';

//                 trigger OnAction()
//                 begin
//                     OpenTimeSheetPage;
//                 end;
//             }
//             action(Submit)
//             {
//                 ApplicationArea = Jobs;
//                 Caption = '&Submit';
//                 Image = ReleaseDoc;
//                 Promoted = true;
//                 PromotedCategory = Process;
//                 PromotedIsBig = true;
//                 ShortCutKey = 'F9';
//                 ToolTip = 'Submit the time sheet for approval.';

//                 trigger OnAction()
//                 begin
//                     SubmitLines;
//                 end;
//             }
//             action(Import)
//             {
//                 ApplicationArea = All;
//                 Caption = 'Import';
//                 ToolTip = 'Import Time sheet';
//                 Promoted = true;
//                 PromotedIsBig = true;
//                 PromotedCategory = Process;
//                 Image = ImportExcel;
//                 RunObject = report "Import Time Entry";
//             }
//         }
//     }

//     trigger OnAfterGetRecord()
//     begin
//         if TimeSheetHeader.Get(Rec."Time Sheet No.") then;
//         if Resource.Get(TimeSheetHeader."Resource No.") then;
//         TimeSheetCommentLine.SetRange("No.", Rec."Time Sheet No.");
//         TimeSheetCommentLine.SetRange("Time Sheet Line No.", Rec."Line No.");
//         if TimeSheetCommentLine.FindFirst() then;
//     end;

//     procedure SetColumns()
//     var
//         Calendar: Record Date;
//     begin
//         Clear(ColumnCaption);
//         Clear(ColumnRecords);
//         Clear(Calendar);
//         Clear(NoOfColumns);


//         GetTimeSheetHeader();
//         Calendar.SetRange("Period Type", Calendar."Period Type"::Date);
//         Calendar.SetRange("Period Start", TimeSheetHeader."Starting Date", TimeSheetHeader."Ending Date");
//         if Calendar.FindSet then
//             repeat
//                 NoOfColumns += 1;
//                 ColumnRecords[NoOfColumns]."Period Start" := Calendar."Period Start";
//                 ColumnCaption[NoOfColumns] := TimeSheetMgt.FormatDate(Calendar."Period Start", 1);
//             until Calendar.Next() = 0;
//     end;

//     local procedure GetTimeSheetHeader()
//     begin
//         TimeSheetHeader.Get(CurrTimeSheetNo);

//         OnAfterGetTimeSheetHeader(TimeSheetHeader);
//     end;

//     local procedure AfterGetCurrentRecord()
//     var
//         i: Integer;
//     begin
//         i := 0;
//         while i < NoOfColumns do begin
//             i := i + 1;
//             if ("Line No." <> 0) and TimeSheetDetail.Get(
//                  "Time Sheet No.",
//                  "Line No.",
//                  ColumnRecords[i]."Period Start")
//             then
//                 CellData[i] := TimeSheetDetail.Quantity
//             else
//                 CellData[i] := 0;
//         end;
//         AllowEdit := Status in [Status::Open, Status::Rejected];
//     end;

//     local procedure ValidateQuantity(ColumnNo: Integer)
//     begin
//         if (CellData[ColumnNo] <> 0) and (Type = Type::" ") then
//             Error(Text001);

//         if TimeSheetDetail.Get(
//              "Time Sheet No.",
//              "Line No.",
//              ColumnRecords[ColumnNo]."Period Start")
//         then begin
//             if CellData[ColumnNo] <> TimeSheetDetail.Quantity then
//                 TestTimeSheetLineStatus;

//             if CellData[ColumnNo] = 0 then
//                 TimeSheetDetail.Delete
//             else begin
//                 TimeSheetDetail.Quantity := CellData[ColumnNo];
//                 TimeSheetDetail.Modify(true);
//             end;
//         end else
//             if CellData[ColumnNo] <> 0 then begin
//                 TestTimeSheetLineStatus;

//                 TimeSheetDetail.Init();
//                 TimeSheetDetail.CopyFromTimeSheetLine(Rec);
//                 TimeSheetDetail.Date := ColumnRecords[ColumnNo]."Period Start";
//                 TimeSheetDetail.Quantity := CellData[ColumnNo];
//                 TimeSheetDetail.Insert(true);
//             end;
//     end;

//     local procedure Process("Action": Option "Submit Selected","Submit All","Reopen Selected","Reopen All")
//     var
//         TimeSheetLine: Record "Time Sheet Line";
//         TempTimeSheetLine: Record "Time Sheet Line" temporary;
//         ActionType: Option Submit,Reopen;
//         JobJournalLine: Record "Job Journal Line";
//         JobJournalBatch: Record "Job Journal Batch";
//     begin
//         CurrPage.SaveRecord;
//         case Action of
//             Action::"Submit All":
//                 FilterAllLines(TimeSheetLine, ActionType::Submit);
//             Action::"Reopen All":
//                 FilterAllLines(TimeSheetLine, ActionType::Reopen);
//             else
//                 CurrPage.SetSelectionFilter(TimeSheetLine);
//         end;
//         OnProcessOnAfterTimeSheetLinesFiltered(TimeSheetLine, Action);
//         TimeSheetMgt.CopyFilteredTimeSheetLinesToBuffer(TimeSheetLine, TempTimeSheetLine);
//         if TimeSheetLine.FindSet then
//             repeat
//                 case Action of
//                     Action::"Submit Selected",
//                   Action::"Submit All":
//                         TimeSheetApprovalMgt.Submit(TimeSheetLine);
//                     Action::"Reopen Selected",
//                   Action::"Reopen All":
//                         TimeSheetApprovalMgt.ReopenSubmitted(TimeSheetLine);
//                 end;
//                 CreateJobJournal(TimeSheetLine);
//             until TimeSheetLine.Next() = 0;

//         if JobJournalBatch.FindFirst() then;
//         JobJournalLine.SetRange("Journal Template Name", JobJournalBatch."Journal Template Name");
//         JobJournalLine.SetRange("Journal Batch Name", JobJournalBatch.Name);
//         //if JobJournalLine.FindSet() then
//         CODEUNIT.Run(Codeunit::"Job Jnl.-Post", JobJournalLine);

//         OnAfterProcess(TempTimeSheetLine, Action);
//         CurrPage.Update(true);
//     end;

//     local procedure CellDataOnAfterValidate()
//     begin
//         CalcFields("Total Quantity");
//     end;

//     local procedure TestTimeSheetLineStatus()
//     var
//         TimeSheetLine: Record "Time Sheet Line";
//     begin
//         TimeSheetLine.Get("Time Sheet No.", "Line No.");
//         TimeSheetLine.TestStatus;
//     end;

//     local procedure SubmitLines()
//     var
//         "Action": Option "Submit Selected","Submit All","Reopen Selected","Reopen All";
//         ActionType: Option Submit,Reopen;
//         IsHandled: Boolean;
//     begin
//         IsHandled := false;
//         OnBeforeSubmitLines(Rec, IsHandled);
//         if IsHandled then
//             exit;

//         case ShowDialog(ActionType::Submit) of
//             1:
//                 Process(Action::"Submit All");
//             2:
//                 Process(Action::"Submit Selected");
//         end;
//     end;

//     local procedure ReopenLines()
//     var
//         ActionType: Option Submit,Reopen;
//         "Action": Option "Submit Selected","Submit All","Reopen Selected","Reopen All";
//         IsHandled: Boolean;
//     begin
//         IsHandled := false;
//         OnBeforeReopenLines(Rec, IsHandled);
//         if IsHandled then
//             exit;

//         case ShowDialog(ActionType::Reopen) of
//             1:
//                 Process(Action::"Reopen All");
//             2:
//                 Process(Action::"Reopen Selected");
//         end;
//     end;

//     local procedure TimeAllocation()
//     var
//         TimeSheetAllocation: Page "Time Sheet Allocation";
//         AllocatedQty: array[7] of Decimal;
//     begin
//         TestField(Posted, true);
//         CalcFields("Total Quantity");
//         TimeSheetAllocation.InitParameters("Time Sheet No.", "Line No.", "Total Quantity");
//         if TimeSheetAllocation.RunModal = ACTION::OK then begin
//             TimeSheetAllocation.GetAllocation(AllocatedQty);
//             TimeSheetMgt.UpdateTimeAllocation(Rec, AllocatedQty);
//         end;
//     end;

//     local procedure GetDialogText(ActionType: Option Submit,Reopen): Text[100]
//     var
//         TimeSheetLine: Record "Time Sheet Line";
//     begin
//         FilterAllLines(TimeSheetLine, ActionType);
//         exit(TimeSheetApprovalMgt.GetTimeSheetDialogText(ActionType, TimeSheetLine.Count));
//     end;

//     local procedure FilterAllLines(var TimeSheetLine: Record "Time Sheet Line"; ActionType: Option Submit,Reopen)
//     begin
//         TimeSheetLine.SetRange("Time Sheet No.", CurrTimeSheetNo);
//         TimeSheetLine.CopyFilters(Rec);
//         TimeSheetLine.FilterGroup(2);
//         TimeSheetLine.SetFilter(Type, '<>%1', TimeSheetLine.Type::" ");
//         TimeSheetLine.FilterGroup(0);
//         case ActionType of
//             ActionType::Submit:
//                 TimeSheetLine.SetFilter(Status, '%1|%2', TimeSheetLine.Status::Open, TimeSheetLine.Status::Rejected);
//             ActionType::Reopen:
//                 TimeSheetLine.SetRange(Status, TimeSheetLine.Status::Submitted);
//         end;

//         OnAfterFilterAllLines(TimeSheetLine, ActionType);
//     end;

//     local procedure ShowDialog(ActionType: Option Submit,Reopen): Integer
//     begin
//         exit(StrMenu(GetDialogText(ActionType), 1, TimeSheetApprovalMgt.GetTimeSheetDialogInstruction(ActionType)));
//     end;

//     local procedure OpenTimeSheetPage()
//     var
//         TimeSheetLine: Record "Time Sheet Line";
//     begin
//         TimeSheetMgt.SetTimeSheetNo(TimeSheetHeader."No.", TimeSheetLine);
//         PAGE.Run(PAGE::"Time Sheet", TimeSheetLine);
//     end;

//     local procedure CreateJobJournal(TimeSheetLine: Record "Time Sheet Line")
//     var
//         JobJournalLines: Record "Job Journal Line";
//         JobJournalBatch: Record "Job Journal Batch";
//         TimeSheetHeaderL: Record "Time Sheet Header";
//         JobJournalLine1: Record "Job Journal Line";
//         Resource: Record Resource;
//         LineNo: Integer;
//     begin
//         if not JobJournalBatch.FindFirst() then
//             exit;

//         LineNo := 10000;
//         JobJournalLine1.SetRange("Journal Template Name", JobJournalBatch."Journal Template Name");
//         JobJournalLine1.SetRange("Journal Batch Name", JobJournalBatch.Name);
//         if JobJournalLine1.FindLast() then
//             LineNo := JobJournalLine1."Line No." + LineNo;

//         JobJournalLines.Init();
//         JobJournalLines.Validate("Journal Template Name", JobJournalBatch."Journal Template Name");
//         JobJournalLines.Validate("Journal Batch Name", JobJournalBatch.Name);
//         JobJournalLines.Validate("Line No.", LineNo);
//         JobJournalLines.Validate("Job No.", TimeSheetLine."Job No.");
//         JobJournalLines.Validate("Job Task No.", TimeSheetLine."Job Task No.");
//         JobJournalLines.Validate("Posting Date", TimeSheetLine."Time Sheet Starting Date");
//         TimeSheetHeaderL.Get(TimeSheetLine."Time Sheet No.");
//         JobJournalLines.validate(Type, JobJournalLines.Type::Resource);
//         Resource.Get(TimeSheetHeaderL."Resource No.");
//         //JobJournalLines."No." := 'KATHERINE';//Test
//         JobJournalLines."No." := TimeSheetHeaderL."Resource No.";
//         JobJournalLines.Validate("Gen. Prod. Posting Group", Resource."Gen. Prod. Posting Group");
//         JobJournalLines.Validate("Unit of Measure Code", Resource."Base Unit of Measure");
//         JobJournalLines.Validate(Description, TimeSheetLine.Description);
//         JobJournalLines.Validate(Quantity, TimeSheetLine."Total Quantity");
//         JobJournalLines.Validate("Document No.", TimeSheetLine."Job No.");
//         JobJournalLines.Insert(true);
//     end;

//     [IntegrationEvent(false, false)]
//     local procedure OnAfterFilterAllLines(var TimeSheetLine: Record "Time Sheet Line"; ActionType: Option Submit,Reopen)
//     begin
//     end;

//     [IntegrationEvent(false, false)]
//     local procedure OnAfterGetTimeSheetHeader(var TimeSheetHeader: Record "Time Sheet Header");
//     begin
//     end;

//     [IntegrationEvent(false, false)]
//     local procedure OnProcessOnAfterTimeSheetLinesFiltered(var TimeSheetLine: Record "Time Sheet Line"; "Action": Option "Submit Selected","Submit All","Reopen Selected","Reopen All")
//     begin
//     end;

//     [IntegrationEvent(false, false)]
//     local procedure OnAfterProcess(var TimeSheetLine: Record "Time Sheet Line"; "Action": Option "Submit Selected","Submit All","Reopen Selected","Reopen All")
//     begin
//     end;

//     [IntegrationEvent(false, false)]
//     local procedure OnBeforeReopenLines(var TimeSheetLine: Record "Time Sheet Line"; var IsHandled: Boolean);
//     begin
//     end;

//     [IntegrationEvent(false, false)]
//     local procedure OnBeforeSubmitLines(var TimeSheetLine: Record "Time Sheet Line"; var IsHandled: Boolean);
//     begin
//     end;

//     var
//         Resource: Record Resource;
//         TimeSheetHeader: Record "Time Sheet Header";
//         TimeSheetCommentLine: Record "Time Sheet Comment Line";
//         TimeSheetDetail: Record "Time Sheet Detail";
//         ColumnRecords: array[32] of Record Date;
//         TimeSheetMgt: Codeunit "Time Sheet Management";
//         TimeSheetApprovalMgt: Codeunit "Time Sheet Approval Management";
//         NoOfColumns: Integer;
//         CellData: array[32] of Decimal;
//         ColumnCaption: array[32] of Text[1024];
//         CurrTimeSheetNo: Code[20];
//         SetWanted: Option Previous,Next;
//         Text001: Label 'The type of time sheet line cannot be empty.';
//         Text003: Label 'Could not find job planning lines.';
//         Text004: Label 'There are no time sheet lines to copy.';
//         Text009: Label 'Do you want to copy lines from the previous time sheet (%1)?';
//         Text010: Label 'Do you want to create lines from job planning (%1)?';
//         AllowEdit: Boolean;
//         DimensionCaptionTok: Label 'Dimensions';
//         JobJnlReconcile: page "Job Journal Reconcile";
// }