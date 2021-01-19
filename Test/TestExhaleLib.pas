unit TestExhaleLib;
{

  Delphi DUnit-Testfall
  ----------------------
  Diese Unit enthält ein Skeleton einer Testfallklasse, das vom Experten für Testfälle erzeugt wurde.
  Ändern Sie den erzeugten Code so, dass er die Methoden korrekt einrichtet und aus der
  getesteten Unit aufruft.

}

interface

uses
  System.SysUtils, TestFramework, LibExhale;

type
  TestTTestClass = class(TTestCase)
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestAacEncoder;
  end;

implementation

uses
  Classes;

{ TestTTestClass }

procedure TestTTestClass.SetUp;
begin
  // do nothing here so far
end;

procedure TestTTestClass.TearDown;
begin
  // do nothing here so far
end;

procedure TestTTestClass.TestAacEncoder;
var
  InputData: PInteger;
  OutputData: PByte;
  Handle: PExhaleEncAPI;
  AudioConfigBytes: Cardinal;
  Error: Cardinal;
begin
  Assert(SizeOf(TExhaleVariableBitrate) = 4);

  // get buffer for one second
  GetMem(InputData, 44100 * SizeOf(Integer));
  GetMem(OutputData, 768 * SizeOf(Integer));

  Handle := ExhaleCreate(InputData, OutputData, 44100, 1, 1024, 45, 4, True);

  Error := ExhaleInitEncoder(Handle, nil, @AudioConfigBytes);
  CheckEquals(0, Error);

  Error := exhaleEncodeLookahead(Handle);
  CheckTrue((Error > 2) and (Error < 65534));

  Error := exhaleEncodeFrame(Handle);
  CheckTrue((Error > 2) and (Error < 65534));

  ExhaleDelete(Handle);
end;

initialization
  RegisterTest(TestTTestClass.Suite);

end.

