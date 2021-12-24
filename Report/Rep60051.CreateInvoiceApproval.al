report 60051 "Create Invoice Approval"
{
    ApplicationArea = All;
    Caption = 'Invoice Approval';
    UsageCategory = Tasks;
    ProcessingOnly = true;

    dataset
    {
        dataitem(Job; Job)
        {
            CalcFields = "Salesperson Code";
            RequestFilterFields = "Salesperson Code";
            dataitem("Job Planning Line"; "Job Planning Line")
            {
                DataItemTableView = where(Quantity = filter(<> 0), Complete = filter(false));
                DataItemLink = "Job No." = field("No.");
                RequestFilterFields = "Planning Date";
                CalcFields = "Qty. Invoiced";


                trigger OnPreDataItem()
                var
                    JobPlanningLine: Record "Job Planning Line";
                    Item: Record Item;
                begin
                    // JobPlanningLine.Reset();
                    // JobPlanningLine.SetRange("Job No.", Job."No.");
                    // JobPlanningLine.SetRange(Complete, false);
                    // if JobPlanningLine.FindSet() then
                    //     repeat
                    //         if JobPlanningLine.Type <> JobPlanningLine.Type::Item then begin
                    //             JobPlanningLine.Complete := true;
                    //             JobPlanningLine.Modify(true);
                    //         end
                    //         else begin
                    //             Item.Get(JobPlanningLine."No.");
                    //             if (not Item."Recurring Services") or (Item.Type <> Item.Type::Inventory) then begin
                    //                 JobPlanningLine.Complete := true;
                    //                 JobPlanningLine.Modify(true);
                    //             end;
                    //         end;
                    //     until JobPlanningLine.Next() = 0;

                    "Job Planning Line".SetCurrentKey("Job No.", "Line No.");
                    Clear(SubTotal);

                    if CreateNewSheet then begin
                        ExcelBuffer.DeleteAll();
                        ExcelBuffer.ClearNewRow();
                        ExcelBuffer.CreateNewBook(Job."Salesperson Code");
                        ExcelBuffer.SelectOrAddSheet(Job."Salesperson Code");

                        ExcelBuffer.NewRow();
                        ExcelBuffer.AddColumn('Relationship Manager', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
                        ExcelBuffer.AddColumn('Currency', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
                        ExcelBuffer.AddColumn('Client #', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
                        ExcelBuffer.AddColumn('SI #', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
                        ExcelBuffer.AddColumn('SI Description', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
                        ExcelBuffer.AddColumn('Work Description', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
                        ExcelBuffer.AddColumn('Code', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
                        ExcelBuffer.AddColumn('Narration', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
                        ExcelBuffer.AddColumn('Amount', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);

                        CreateNewSheet := false;
                    end;
                end;

                trigger OnAfterGetRecord()
                var
                begin
                    // Supriya
                    if "Job Planning Line"."Unit Price" * "Job Planning Line".Quantity <> 0 then begin
                        ExcelBuffer.NewRow();
                        if (Job."No." <> JobNo) then begin
                            if (SalesPersonCode <> '') and (Job."Salesperson Code" <> SalesPersonCode) then begin
                                ExcelBuffer.AddColumn(SalesPersonPurchaser.Name, false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
                                ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                                ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                                ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                                ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                                ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                                ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                                ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                                ExcelBuffer.AddColumn(Total, false, '', true, false, false, '', ExcelBuffer."Cell Type"::Number);
                                ExcelBuffer.NewRow();
                                Clear(Total);

                                ExcelBuffer.WriteSheet(SalesPersonCode, CompanyName, UserId);

                                ExcelBuffer.DeleteAll();
                                ExcelBuffer.ClearNewRow();
                                // ExcelBuffer.CreateNewBook(Job."Salesperson Code");
                                ExcelBuffer.SelectOrAddSheet(Job."Salesperson Code");

                                ExcelBuffer.NewRow();
                                ExcelBuffer.AddColumn('Relationship Manager', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
                                ExcelBuffer.AddColumn('Currency', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
                                ExcelBuffer.AddColumn('Client #', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
                                ExcelBuffer.AddColumn('SI #', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
                                ExcelBuffer.AddColumn('SI Description', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
                                ExcelBuffer.AddColumn('Work Description', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
                                ExcelBuffer.AddColumn('Code', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
                                ExcelBuffer.AddColumn('Narration', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
                                ExcelBuffer.AddColumn('Amount', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
                                ExcelBuffer.NewRow();
                            end;

                            ExcelBuffer.NewRow();
                            if SalesPersonPurchaser.Get(Job."Salesperson Code") then;
                            ExcelBuffer.AddColumn(SalesPersonPurchaser.Name, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                            if Job."Currency Code" = '' then
                                ExcelBuffer.AddColumn('NZD', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text)
                            else
                                ExcelBuffer.AddColumn(Job."Currency Code", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                            ExcelBuffer.AddColumn(Job."Bill-to Customer No.", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                            ExcelBuffer.AddColumn(Job."No.", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                            ExcelBuffer.AddColumn(Job.Description, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                            ExcelBuffer.AddColumn(CopyStr(Job."Work Description", 1, 250), false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                        end else begin
                            ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                            ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                            ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                            ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                            ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                            ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                        end;

                        ExcelBuffer.AddColumn("Job Planning Line"."No.", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                        ExcelBuffer.AddColumn(CopyStr("Job Planning Line"."Work description", 1, 250), false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

                        ExcelBuffer.AddColumn("Job Planning Line"."Unit Price" * "Job Planning Line".Quantity, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);

                        JobNo := Job."No.";
                        SalesPersonCode := Job."Salesperson Code";

                        SubTotal += "Job Planning Line"."Unit Price" * "Job Planning Line".Quantity;
                        Total += "Job Planning Line"."Unit Price" * "Job Planning Line".Quantity;
                    end;
                end;

                trigger OnPostDataItem()
                var
                begin
                    if SubTotal <> 0 then begin
                        ExcelBuffer.NewRow();
                        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                        ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                        ExcelBuffer.AddColumn(SubTotal, false, '', true, false, false, '', ExcelBuffer."Cell Type"::Number);
                        ExcelBuffer.NewRow();
                    end;
                end;
            }

            trigger OnPreDataItem()
            var
            begin
                Clear(Total);
                Clear(JobNo);
                Clear(SalesPersonCode);

                Job.SetCurrentKey("Salesperson Code");
                Job.SetAscending("Salesperson Code", true);

                CreateNewSheet := true;
            end;

            trigger OnAfterGetRecord()
            var
                SalesPerson: Record "Salesperson/Purchaser";
            begin
                Job.CalcFields("Salesperson Code");
                if Job."Salesperson Code" <> '' then
                    if SalesPerson.Get(Job."Salesperson Code") then
                        if not Recipients.Contains(SalesPerson."E-Mail") then
                            Recipients.Add(SalesPerson."E-Mail");
            end;

            trigger OnPostDataItem()
            var
            begin
                ExcelBuffer.NewRow();
                ExcelBuffer.AddColumn(SalesPersonPurchaser.Name, false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(Total, false, '', true, false, false, '', ExcelBuffer."Cell Type"::Number);
                ExcelBuffer.NewRow();
                ExcelBuffer.WriteSheet(Job."Salesperson Code", CompanyName, UserId);
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(content)
            {
                group(GroupName)
                {
                }
            }
        }
        actions
        {
            area(processing)
            {
            }
        }
    }
    trigger OnInitReport()
    begin
        ExcelBuffer.DeleteAll();
    end;

    trigger OnPostReport()
    var
        TempBlob: Codeunit "Temp Blob";
        Base64: Codeunit "Base64 Convert";
        ResultOutStream: OutStream;
        ResultInStream: InStream;
        ExcelFile: Text;
    begin
        // ExcelBuffer.CreateNewBook('Invoice Approval Report');
        // ExcelBuffer.WriteSheet('Invoice Approval Report', CompanyName, UserId);
        ExcelBuffer.CloseBook();
        // ExcelBuffer.OpenExcel();

        Clear(ResultOutStream);
        Clear(ResultInStream);
        TempBlob.CreateOutStream(ResultOutStream);
        TempBlob.CreateInStream(ResultInStream);
        ExcelBuffer.SaveToStream(ResultOutStream, false);
        if TempBlob.HasValue() then begin
            SubjectText := 'Invoice Approval Report';
            LongBodyText := 'Hi,<br><br>Please find Invoice Approval Report in the Attachment<br><br>Regards,<br>' + CompanyName;
            EmailMessageCOD.Create(Recipients, SubjectText, LongBodyText, true, CCRecipients, BCCRecipients);
            EmailMessageCOD.AddAttachment('Invoice Approval Report.xlsx', 'EXCEL', ResultInStream);
            EmailCOD.OpenInEditor(EmailMessageCOD);
        end;
    end;

    var
        EmailCOD: Codeunit Email;
        EmailMessageCOD: Codeunit "Email Message";
        ExcelBuffer: Record "Excel Buffer" temporary;
        SalesPersonPurchaser: Record "Salesperson/Purchaser";
        SalesPersonCode: Code[20];
        JobNo: Code[50];
        SubjectText: Text;
        LongBodyText: Text;
        Recipients: List of [Text];
        CCRecipients: List of [Text];
        BCCRecipients: List of [Text];
        SubTotal: Decimal;
        Total: Decimal;
        CreateNewSheet: Boolean;
}
