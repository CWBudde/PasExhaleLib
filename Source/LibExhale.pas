unit LibExhale;

interface

{-$DEFINE DynLink}

const
{$IF Defined(MSWINDOWS)}
  CLibExhale = 'exhaleLib.dll';
{$IFEND}

type
  TExhaleEncAPI = record
  end;
  PExhaleEncAPI = ^TExhaleEncAPI;

  TExhaleVariableBitrate = Integer;

{$IFDEF DynLink}
  // static linking
  TExhaleCreate = function (const inputPcmData: PInteger; const outputAuData: PByte; const SampleRate: Cardinal; const numChannels: Cardinal; const frameLength: Cardinal; const indepPeriod: Cardinal; const varBitRateMode: TExhaleVariableBitrate; const useNoiseFill: Boolean): PExhaleEncAPI; cdecl;
  TExhaleDelete = function (const ExhaleEncAPI: PExhaleEncAPI): Cardinal; cdecl;
  TExhaleInitEncoder = function (const ExhaleEncAPI: PExhaleEncAPI; const audioConfigBuffer: PByte; const audioConfigBytes: PCardinal): Cardinal; cdecl;
  TExhaleEncodeLookahead = function (const ExhaleEncAPI: PExhaleEncAPI): Cardinal; cdecl;
  TExhaleEncodeFrame = function (const ExhaleEncAPI: PExhaleEncAPI): Cardinal; cdecl;

var
  ExhaleCreate: TExhaleCreate;
  ExhaleDelete: TExhaleDelete;
  ExhaleInitEncoder: TExhaleInitEncoder;
  ExhaleEncodeLookahead: TExhaleEncodeLookahead;
  ExhaleEncodeFrame: TExhaleEncodeFrame;

{$ELSE}
  // static linking
  function ExhaleCreate(const inputPcmData: PInteger; const outputAuData: PByte; const SampleRate: Cardinal; const numChannels: Cardinal; const frameLength: Cardinal; const indepPeriod: Cardinal; const varBitRateMode: TExhaleVariableBitrate; const useNoiseFill: Boolean): PExhaleEncAPI; cdecl; external CLibExhale name 'exhaleCreate';
  function ExhaleDelete(const ExhaleEncAPI: PExhaleEncAPI): Cardinal; cdecl; external CLibExhale name 'exhaleDelete';
  function ExhaleInitEncoder(const ExhaleEncAPI: PExhaleEncAPI; const audioConfigBuffer: PByte; const audioConfigBytes: PCardinal): Cardinal; cdecl; external CLibExhale name 'exhaleInitEncoder';
  function ExhaleEncodeLookahead(const ExhaleEncAPI: PExhaleEncAPI): Cardinal; cdecl; external CLibExhale name 'exhaleEncodeLookahead';
  function ExhaleEncodeFrame(const ExhaleEncAPI: PExhaleEncAPI): Cardinal; cdecl; external CLibExhale name 'exhaleEncodeFrame';

{$ENDIF}

implementation

uses
  System.SysUtils
{$IFDEF DynLink}
{$IFDEF FPC}
  , DynLibs;
{$ELSE}
{$IFDEF MSWindows}
  , Windows;
{$ENDIF}
{$ENDIF}
{$ELSE}
  ;
{$ENDIF}

{$IFDEF DynLink}
var
  CLibExhaleHandle: {$IFDEF FPC}TLibHandle{$ELSE}HINST{$ENDIF};

procedure InitDLL;

  function BindFunction(Name: AnsiString): Pointer;
  begin
    Result := GetProcAddress(CLibExhaleHandle, PAnsiChar(Name));
    Assert(Assigned(Result));
  end;

begin
  {$IFDEF FPC}
  CLibExhaleHandle := LoadLibrary(CLibExhale);
  {$ELSE}
  CLibExhaleHandle := LoadLibraryA(CLibExhale);
  {$ENDIF}
  if CLibExhaleHandle <> 0 then
    try
      ExhaleCreate := BindFunction('exhaleCreate');
      ExhaleDelete := BindFunction('exhaleDelete');
      ExhaleInitEncoder := BindFunction('exhaleInitEncoder');
      ExhaleEncodeLookahead := BindFunction('exhaleEncodeLookahead');
      ExhaleEncodeFrame := BindFunction('exhaleEncodeFrame');
    except
      FreeLibrary(CLibExhaleHandle);
      CLibExhaleHandle := 0;
    end;
end;

procedure FreeDLL;
begin
  if CLibExhaleHandle <> 0 then
    FreeLibrary(CLibExhaleHandle);
end;
{$ELSE}
{$ENDIF}

{$IFDEF DynLink}
initialization
  InitDLL;

finalization
  FreeDLL;
{$ENDIF}

end.
