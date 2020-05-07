unit uVisualizarDados;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  System.JSON, System.Generics.Collections, FMX.Types, FMX.Controls, FMX.Forms,
  FMX.Graphics, FMX.Dialogs, FMX.Layouts, FMX.Objects, FMX.Controls.Presentation,
  FMX.ScrollBox, FMX.Memo, FMX.StdCtrls, FMX.Menus, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.Phys.MySQL, FireDAC.Phys.MySQLDef, FireDAC.Dapt, FireDAC.FMXUI.Wait,
  Data.DB, FireDAC.Comp.Client;

type
  TLayoutHelper = class helper for TLayout
    procedure GridJson(JSON: string);
    procedure GridSQL(SQL: string);
  end;

implementation

{ TLayoutHelper }

procedure TLayoutHelper.GridJson(JSON: string);
var
  JSONValue, JSONValue2: TJSONValue;
  JSONArray, JSONArray2: TJSONArray;
  JSONObject, JSONObject2: TJSONObject;
  Loop1, Loop2, Loop3, Loop4: Integer;
  vab: TVertScrollBox;
  lay: TLayout;
  ret: TRectangle;
  txt: TText;
begin

  try
    JSONValue := TJSONObject.ParseJSONValue(JSON);

      {garantir que seja um JSONArray}
    if (JSONValue is TJSONObject) then
    begin
      FreeAndNil(JSONValue);
      JSONValue := TJSONObject.ParseJSONValue('[' + JSON + ']');
    end;

    if (JSONValue is TJSONArray) then
    begin
      try
        JSONArray := TJsonObject.ParseJSONValue(JSONValue.ToJSON) as TJSONArray;
            //Criar um VertScrollBox
        vab := TVertScrollBox.Create(Self);
        vab.Align := TAlignLayout.Client;
        vab.Parent := Self;

        for Loop1 := 0 to JSONArray.Count - 1 do
        begin
          try
                  //Criar um TLayout para cada objeto do Array
            lay := TLayout.Create(vab);
            lay.Align := TAlignLayout.Top;
            lay.Height := 25;
            lay.ClipChildren := True;
            lay.HitTest := True;
            lay.Parent := vab;


                  //Criar um TRectangle para cada objeto do Array
            ret := TRectangle.Create(lay);
            ret.Align := TAlignLayout.Top;
            ret.Fill.Color := 4281610031;
            ret.Stroke.Color := 4281610031;
            ret.Height := 25;
            ret.HitTest := False;
            ret.Parent := lay;

            JSONObject := TJSONObject.ParseJSONValue(JSONArray.Items[Loop1].ToJSON) as TJSONObject;
            for Loop2 := 0 to JSONObject.count - 1 do
            begin

              try
                JSONValue2 := TJSONObject.ParseJSONValue(JSONObject.Pairs[Loop2].JSONValue.ToJSON);
                if (JSONValue2 is TJSONArray) then
                begin
                  try
                    JSONArray2 := TJSONObject.ParseJSONValue(JSONValue2.ToJSON) as TJSONArray;
                    ;
                              //Incrementar Altura do TLayout
                              lay.Height:=25 * (JSONArray2.Count + 1);

                    for Loop3 := 0 to JSONArray2.Count - 1 do
                    begin
                                 //Criar um TRectangle para cada objeto do Array
                      ret := TRectangle.Create(lay);
                      ret.Align := TAlignLayout.Top;
                      ret.Fill.Color := 4281610031;
                      ret.Stroke.Color := 4281610031;
                      ret.Height := 25;
                      ret.HitTest := False;
                      ret.Parent := lay;

                      try
                        JSONObject2 := TJSONObject.ParseJSONValue(JSONArray2.Items[Loop3].ToJSON) as TJSONObject;
                        for Loop4 := 0 to JSONObject2.count - 1 do
                        begin
                                        //Criar os campos no Detalhes
                          txt := TText.Create(ret);
                          txt.Align := TAlignLayout.Left;
                          txt.Width := 200;
                          txt.Margins.Left := 20;
                          txt.Position.X := Self.Width;
                          txt.TextSettings.HorzAlign := TTextAlign.Leading;
                          txt.TextSettings.FontColor := Talphacolors.White;
                          txt.Parent := ret;
                          txt.Text := JSONObject2.Pairs[Loop4].JSONValue.Value;
                        end;

                      finally
                        JSONObject2.Free;
                      end;

                    end;

                  finally
                    JSONArray2.Free;
                  end;

                end
                else
                begin
                           // criar os campos no cabeçalho
                  txt := TText.Create(ret);
                  txt.Align := TAlignLayout.Left;
                  txt.Width := 200;
                  txt.Margins.Left := 5;
                  txt.Position.X := Self.Width;
                  txt.TextSettings.HorzAlign := TTextAlign.Leading;
                  txt.TextSettings.FontColor := Talphacolors.Gold;
                  txt.Parent := ret;
                  txt.Text := JSONObject.Pairs[Loop2].JSONValue.Value;
                end;
              finally
                JSONValue2.Free;
              end;
            end;

          finally
            JSONObject.Free;
          end;
        end;

      finally
        JSONArray.Free;
      end;

    end;

  finally

    JSONValue.Free;

  end;

end;

procedure TLayoutHelper.GridSQL(SQL: string);
begin

end;

end.

