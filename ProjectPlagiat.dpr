program ProjectPlagiat;

uses
  Forms,
  UnitAP in 'UnitAP.pas' {Form1},
  tekAntiPlagiat in 'tekAntiPlagiat.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
