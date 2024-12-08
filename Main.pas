unit Main;

interface

uses
    Winapi.Windows, Winapi.Messages, System.SysUtils, System.StrUtils,
    System.Variants,
    System.Classes, Vcl.Graphics,
    Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, Vcl.StdCtrls;

type
    TForm8 = class(TForm)
        Memo1: TMemo;
        Button1: TButton;
        Button2: TButton;
        MainMenu1: TMainMenu;
        File1: TMenuItem;
        Open1: TMenuItem;
        Save1: TMenuItem;
        OpenDialog1: TOpenDialog;
        SaveDialog1: TSaveDialog;
        procedure Open1Click(Sender: TObject);
        procedure Save1Click(Sender: TObject);
        procedure Button1Click(Sender: TObject);
        procedure Button2Click(Sender: TObject);
    private
        { Private declarations }
    public
        { Public declarations }
        procedure LoadFileToMemo;
        procedure SaveMemoToFile;
        procedure CryptMemo;
        procedure DecryptMemo;
    end;

var
    Form8: TForm8;

implementation

{$R *.dfm}

procedure TForm8.LoadFileToMemo;
begin
    if OpenDialog1.Execute then
    begin
        Memo1.Clear;
        Memo1.Lines.LoadFromFile(OpenDialog1.FileName);
    end;
end;

procedure TForm8.Open1Click(Sender: TObject);
begin
    LoadFileToMemo;
end;

procedure TForm8.Save1Click(Sender: TObject);
begin
    SaveMemoToFile;
end;

procedure TForm8.SaveMemoToFile;
begin
    if SaveDialog1.Execute then
        Memo1.Lines.SaveToFile(SaveDialog1.FileName);
end;

procedure TForm8.Button1Click(Sender: TObject);
begin
    CryptMemo;
end;

procedure TForm8.Button2Click(Sender: TObject);
begin
    DecryptMemo;
end;

procedure TForm8.CryptMemo;
var
    str_list: TstringList;
    i: integer;
    str_text: string; // строка
    small_str: string; // строка из 4 символов
    encrypt_str: string; // криптованная строка из 4 символов
    data_list: array of string;
    size_mod: integer;
begin
    str_list := TstringList.Create;
    // идём построчно
    for str_text in Memo1.Lines do
    begin
        // разбиваем строку по 4 символа, создаём массив строк
        setlength(data_list, 0);
        for i := 0 to (length(str_text) div 4) - 1 do
        begin
            small_str := Copy(str_text, i * 4 + 1, 4);
            // переворачиваем подстроку
            small_str := ReverseString(small_str);
            setlength(data_list, length(data_list) + 1);
            data_list[length(data_list) - 1] := small_str;
        end;
        // дополняем массив строк остатком
        size_mod := length(str_text) mod 4;
        if size_mod > 0 then
        begin
            encrypt_str := Copy(str_text, length(str_text) - size_mod + 1,
              size_mod);
            for i := 0 to length(data_list) - 1 do
                encrypt_str := encrypt_str + data_list[i];
        end
        else
        begin
            encrypt_str := '';
            if length(data_list) > 0 then
            begin
                encrypt_str := data_list[length(data_list) - 1];
                for i := 0 to length(data_list) - 2 do
                    encrypt_str := encrypt_str + data_list[i];
            end;
        end;

        str_list.Add(encrypt_str);
    end;
    Memo1.Lines := str_list;
    str_list.Free;
end;

procedure TForm8.DecryptMemo;
begin

end;

end.
