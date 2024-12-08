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
        function reverse_string_encrypt(str_data: string): string;
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
    str_text: string; // строка
    small_str: string; // строка из 4 символов
    encrypt_str: string; // криптованная строка из 4 символов
    end_str: string; // хвост строки
begin
    str_list := TstringList.Create;
    // идём построчно
    for str_text in Memo1.Lines do
    begin
        // разбиваем строку по 4 символа
        small_str := copy(str_text, 1, length(str_text) -
          (length(str_text) mod 4));
        end_str := copy(str_text, length(small_str) + 1,
          length(str_text) mod 4);
        encrypt_str := reverse_string_encrypt(small_str);
        if length(end_str) > 0 then
        begin
            encrypt_str := end_str + encrypt_str;
        end
        else
        begin
            encrypt_str := copy(encrypt_str, length(encrypt_str) - 3, 4) +
              copy(encrypt_str, 1, length(encrypt_str) - 4);
        end;

        str_list.Add(encrypt_str);
    end;
    Memo1.Lines := str_list;
    str_list.Free;
end;

procedure TForm8.DecryptMemo;
var
    str_list: TstringList;
    str_text: string; // строка
    encrypt_str: string; // криптованная строка из 4 символов
    end_str: string; // хвост строки
begin
    str_list := TstringList.Create;
    // идём построчно
    for str_text in Memo1.Lines do
    begin
        // если строка не кратна 4, то выравниваем по концу
        if (length(str_text) mod 4) > 0 then
        begin
            // строка не кратна 4, берем необхомую длину символов и перемещаем
            end_str := copy(str_text, 1, length(str_text) mod 4);
            encrypt_str := copy(str_text, (length(str_text) mod 4) + 1,
              length(str_text) - length(str_text) mod 4);
            encrypt_str := reverse_string_encrypt(encrypt_str) + end_str;
        end
        else
        begin
            // строка кратна 4, сперва восстанавливаем последовательность
            end_str := copy(str_text, 1, 4);
            encrypt_str := copy(str_text, 5, length(str_text) - 4) + end_str;
            encrypt_str := reverse_string_encrypt(encrypt_str);
        end;

        str_list.Add(encrypt_str);
    end;
    Memo1.Lines := str_list;
    str_list.Free;
end;

function TForm8.reverse_string_encrypt(str_data: string): string;
var
    i: integer;
begin
    result := '';
    for i := 0 to length(str_data) div 4 do
    begin
        result := result + ReverseString(copy(str_data, i * 4 + 1, 4));
    end;

end;

end.
