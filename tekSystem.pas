{===============================================================================
 - Независимый модуль без инициализации и пр. Как стандартный System.
 - Так же тут располагаются: "математика", "мои строки".
 - Автор: TEK и немного божЬей пОмоЩи :)
===============================================================================}
unit tekSystem; // 2012.4.29 TEK (www.TEK.86@Mail.ru) >
//=============================================================================>
//=============================== Раздел обьявлений ===========================>
//=============================================================================>
interface
//=============================================================================>
//================================= Константы =================================>
//=============================================================================>
const
    // Цифры >
  _0 = 0;
  _1 = 1;
  _2 = 2;
  _3 = 3;
  _4 = 4;
  _5 = 5;
  _6 = 6;
  _7 = 7;
  _8 = 8;
  _9 = 9;
  _10 = 10;
  _11 = 11;
  _12 = 12;
  _13 = 13;
  _14 = 14;
  _15 = 15;
  _16 = 16;
  _17 = 17;
  _18 = 18;
  _19 = 19;
  _20 = 20;
  _21 = 21;
  _22 = 22;
  _23 = 23;
  _24 = 24;
  _25 = 25;
  _28 = 28;
  _29 = 29;
  _30 = 30;
  _31 = 31;
  _32 = 32;
  _60 = 60;
  _61 = 61;
  _62 = 62;
  _63 = 63;
  _64 = 64;
  _65 = 65;
  _66 = 66;
  _100 = 100;
  _127 = 127;
  _128 = 128;
  _256 = 256;
  _365 = 365;
  _366 = 366;
  _512 = 512;
  _1000 = 1000;
  _1024 = 1024;
  _2048 = 2048;
  _4096 = 4096;
  _8192 = 8192;
  _65535 = 65535;
    // Цифры прописью >
  mTwo = - _2;
  mOne = - _1;
  Zero = _0;
  One = _1;
  Two = _2;
  Three = _3;
  Four = _4;
  Five = _5;
  Six = _6;
  Seven = _7;
  Eight = _8;
  Nine = _9;
  Ten = _10;
  Eleven = _11;
  Twelve = _12;
    // >
  _X = Zero;
  _Y = One;
  _Z = Two;
  _W = Three;
    // Знаки >
  mgl_Zero = Zero;
  mglZero = Zero;
  Null = Zero;
  First = Zero;
    // Размеры >
  M1K = _1000;
  M2K = Two*_1000;
  M3K = Three*_1000;
  ByteLength = _256;
  ByteMax = ByteLength - One;
  WordMax = _65535;
  ShortNameLength = Ten;
  ShortNameMax = ShortNameLength - One;
  ShortPassLength = Eight;
  ShortPassMax = ShortPassLength - One;
  NodeTotalInc = _2048;
  NodeSelectInc = NodeTotalInc div Two;
  NodeLocalInc = NodeSelectInc div Two;
  NodeSimpleInc = NodeLocalInc div Two;
  FileResetSize = One;
  mnKB = _1024;
  mnMB = mnKB * mnKB;
  mnGB = mnMB * mnKB;
  mnColorDepth = _32;
  mnDepthDepth = _32;
  mnStencilDepth = _32;
  mnFPSDivision = _1000;
    // Время >
  mnMilliSecond = One;
  mnSecond = _1000*mnMilliSecond;
  mnMinute = _60*mnSecond;
  mnHour = _60*mnMinute;
  mnDay = _24*mnHour;
    // Номера дней недели по инглически >
  mnSonday = Zero;
  mnMonday = One;
  mnTuesDay = Two;
  mnWednesDay = Three;
  mnFourthDay = Four;
  mnFriDay = Five;
  mnSaturDary = Six;
    // Нормальный порядок дней недели >
  mrMonday = Zero;
  mrTuesDay = One;
  mrWednesDay = Two;
  mrFourthDay = Three;
  mrFriDay = Four;
  mrSaturDary = Five;
  mrSonday = Six;
    // Ёмкости типов данных >
  cByteSize = SizeOf(Byte);
  cCharSize = SizeOf(Char);
  cWideCharSize = SizeOf(WideChar);
  cWordSize = SizeOf(Word);
  cPointerSize = SizeOf(Pointer);
  cCardinalSize = SizeOf(Cardinal);
  cIntegerSize = SizeOf(Integer);
  cSingleSize = SizeOf(Single);
  cRealSize = SizeOf(Real);
  cDoubleSize = SizeOf(Double);
  cInt64Size = SizeOf(Int64);
    // Длительность >
  PassTryDelay = _1000;
  mnMaxDriveCount = _32;
  mnMaxDrive = mnMaxDriveCount - One;
  mnTestFrameCount = _1024;
    // Тпы узлов >
  mnNode = One;
  mnFile = Two;
  mnFolder = Three;
  mnDrive = Four;
  mnDrives = Five;
  mnComputer = Six;
  mnWindows = Seven;
  mnRAMClass = Eight;
  mnCamera = Nine;
  mnKeyBoard = Ten;
  mnMouse = _11;
  mnDrawLine = _12;
  mnVisibleParams = _13;
  mnVisibleMaterial = _14;
  mnVisibleBodyType = _15;
  mnVisibleBody = _16;
  mnLightSource = _17;
  mnFog = _18;
  mnTexture = _19;
  mnStringList = _20;
  mnExNo = _21;
  mnFileImage = _22;
  mnFolderImage = _23;
  mnDiskImage = _24;
  mnApplication = _25;
    // События от мышки >
  MM_LEFT_DOWN = mgl_Zero;
  MM_LEFT_UP = One;
  MM_LEFT_CLICK = Two;
  MM_LEFT_DOUBLE_CLICK = Three;
  MM_RIGHT_DOWN = Four;
  MM_RIGHT_UP = Five;
  MM_RIGHT_CLICK = Six;
  MM_RIGHT_DOUBLE_CLICK = Seven;
  MM_MIDDLE_DOWN = Eight;
  MM_MIDDLE_UP = Nine;
  MM_MIDDLE_CLICK = Ten;
  MM_MIDDLE_DOUBLE_CLICK = _11;
  MM_WHEELUP = _12;
  MM_WHEELDOWN = _13;
  MM_MOVE = _14;
  MM_MAX = _15;
    // Формы доступа для узлов >
  maNotSet = Zero;
  maNone = One;
  maCanView = Two;
  maCanViewAll = Three;
  maCanEdit = Four;
  maCanEditAll = Five;
  maCanAll = Six;
    // БукАвЪки >
  EmptyChar = Char(Zero);
  mnFirstDriveChar: Char = 'a';
  mnSlash: Char = '\';
  mnDot = '.';
  mnDirIn = mnDot;
  mnTwoDots = ':';
  mnBeckSlash: Char = '/';
  mDivOfCom: Char = ' ';
  mnStrColName = 'l';
  mnLeftBrecket = '(';
  mnRightBrecket = ')';
  mEndLine = _13;
  cEndLine = Char(mEndLine);
  mnBreakLine = Ten;
  cnBreakLine = Char(mnBreakLine);
    // Типы результатов >
  mFalse = Zero;
  mTrue = One;
  mUnKnown = Two;
  mError = Three;
    // Языки >
  mnEng = One; // Английский >
  mnRus = Zero; // Русский >
  mnUkr = Two; // Украинский >
  mnGer = Three; // Немецкий >
    // Строки >
  mnEngDefCharCodesLo = 'qwertyuiopasdfghjklzxcvbnm'; // Английский (нижний регистр) >
  mnEngDefCharCodesHi = 'QWERTYUIOPASDFGHJKLZXCVBNM'; // Английский (верхний регистр) >
  mnRusDefCharCodesLo = 'йцукенгшщзхъфывапролджэячсмитьбюё'; // Русский (нижний регистр) >
  mnRusDefCharCodesHi = 'ЙЦУКЕНГШЩЗХЪФЫВАПРОЛДЖЭЯЧСМИТЬБЮЁ'; // Русский (верхний регистр) >
  mnUkrDefCharCodesLo = 'йцукенгшщзхїфівапроджєячсмитьбю'; // Украинский (нижний регистр) >
  mnUkrDefCharCodesHi = 'ЙЦУКЕНГШЩЗХЇФІВПРОЛДЖЄЯЧСМИТЬБЮ'; // Украинский (верхний регистр) >
  mnGerDefCharCodesLo = 'qwertzuiop?asdfghjkl??yxcvbnm?'; // Немецкий (нижний регистр) >
  mnGerDefCharCodesHi = 'QWERTZUIOP?ASDFGHJKL??YXCVBNM'; // Немецкий (верхний регистр) >
  EmptyString = '';
  mnRusExt = 'rus';
  mnDirNameUp = '..';
  mnDriveApp = ':\';
  mnSearchMask = '*.*';
  mnUsualMask = '\*.*';
  mnDefaultPass = 'First';
  mnLogFileName = 'Log.txt';
  mnMessageRus = 'Сообщение';
  mnNameStr = 'Name';
  mnLinkStr = 'Link';
  mnDescriptionStr = 'Description';
  mnDataStr = 'Data';
  mnArrowLine = ' -> ';
  UnKnownError = 'Неизвестная ошибка';
  mnWindowClassName = 'mglWindowClass'; // Имя класса окна для OpenGL >
    // Расширения >
  mnEXE = 'exe'; // Исполнительный файл (*.exe) >
  mnDLL = 'DLL'; // Динамически подключаемая библиотека >
  mnTXT = 'TXT'; // Текст >
  mnBAT = 'BAT';
  mnBMP = 'BMP'; // Не сжатое изображение >
  mnJPG = 'JPG'; // Картинка "JPG" >
  mnPNG = 'PNG'; // Картинка "PNG" >
  mnTGA = 'TGA'; // Картинка "Targa" >
  mnWAV = 'wav'; // Не сжатый звук (Расширение для *.WAV-файлов) >
  mnOGG = 'OGG'; // Сжатый Vorbis-кодеком "звук" >
  mnMP3 = 'MP3'; // "Mpeg 3 Layer" = "звук" >
  mnTEK = 'TEK'; // Разрешение для моих файлов >
  mnBUC = 'BUC'; // Резервная копия файла любого формата\расширения >
  mnVIRE = 'VIRE'; // Инфицированный вирусом "EXE"-файл >
  mnVIRL = 'VIRL'; // Инфицированный вирусом "DLL"-файл >
  mnVIRB = 'VIRB'; // НЕ ИНФИЦИРОВАННЫЙ (ЗАПАСНОЙ) "EXE"-файл >
  mnGLT = 'GLT'; // Специальное (формализация) расширение для текстового файла содержащего код для шейдера >
  mnVertex = 'Vertex';
  mnFragment = 'Fragment';
    // Значения с плавающей точкой >
  DefFLParam: Single = 0.0000000001;
//=============================================================================>
//==================================== Типы ===================================>
//=============================================================================>
type
    // Тип-адрес (размерность адреса в файле) >
  PMyHDMAddress = ^TMyHDMAddress;
  TMyHDMAddress = Integer;
//----------------------------------------------------------------------------->
//-------------------------------- Простые массивы ---------------------------->
//----------------------------------------------------------------------------->
  PBytePack = ^TBytePack;
  TBytePack = packed array [Zero..Zero] of Byte; // Немеренный массив байт >
  PCharBuffer = PBytePack;
  PWordPack = ^TWordPack;
  TWordPack = packed array [Zero..Zero] of Word; // Немеренный массив слов >
  PCardinalPack = ^TCardinalPack;
  TCardinalPack = packed array [Zero..Zero] of Cardinal; // "Немеренный массив" 32-битных кусочков >
  PIntegerPack = ^TIntegerPack;
  TIntegerPack = packed array [Zero..Zero] of Integer; // "Немеренный массив" 32-битных кусочков, "со знаком" >
  PCharPack = ^TCharPack;
  TCharPack = packed array [Zero..Zero] of Char; // Группа букв >
  PWideCharPack = ^TWideCharPack;
  TWideCharPack = packed array [Zero..Zero] of WideChar; // Немеренный массив "толстых" букавъ >
  PMySingleLine = ^TMySingleLine;
  TMySingleLine = packed array [Byte] of Single; // Для разных параметров с плавающей точкой >
  PMy1f = ^TMy1f;
  TMy1f = array [Zero..Zero] of Single;
  PMy2f = ^TMy2f;
  TMy2f = array [Zero..One] of Single;
  PMy3f = ^TMy3f;
  TMy3f = array [Zero..Two] of Single;
  PMy4f = ^TMy4f;
  TMy4f = array [Zero..Three] of Single;
  PMy5f = ^TMy5f;
  TMy5f = array [Zero..Four] of Single;
  PMy6f = ^TMy6f;
  TMy6f = array [Zero..Five] of Single;
  PMy2fArray = ^TMy2fArray;
  TMy2fArray = array [Zero..Zero] of TMy2f;
  PMy3fArray = ^TMy3fArray;
  TMy3fArray = array [Zero..Zero] of TMy2f;
  TMy4Char = array [Zero..Three] of Char;
  TMyString32 = array [Zero.._31] of Char;
  TMyString64 = array [Zero.._63] of Char;
  TMyString128 = array [Zero.._127] of Char;
  TMyString256 = array [Byte] of Char;
  PMyStrings = ^TMyStrings;
  TMyStrings = array of String;
  TMyLongString = array [Byte] of Char;
  PMyBytes = ^TMyBytes;
  TMyBytes = array [Byte] of Byte;
  PMyBuff = ^TMyBuff;
  TMyBuff = array [Zero..Zero] of Byte; // Сам буффер, представленный в виде сплошного массива байтов >
//----------------------------------------------------------------------------->
//------------------------------- Простые структуры --------------------------->
//----------------------------------------------------------------------------->
  PMyBuffPack = ^TMyBuffPack;
  TMyBuffPack = packed record // Структура для работы с абстрактными буфферами данных >
    mSize: Cardinal;
    pData: PMyBuff;
  end;
    // Моя специальная строка для сохранения на диске и т.д. >
  PMyString = ^TMyString;
  TMyString = packed record
    mSize: Cardinal;
    mUsedSize: Cardinal;
  end;
    // Тип для времени >
  PMyTime = ^TMyTime;
  TMyTime = record
    wYear: Word;
    bMonth: Byte;
    bDay: Byte;
    bDayOfWeek: Byte;
    bHour: Byte;
    bMinute: Byte;
    bSecond: Byte;
    wMillisecond: Word;
  end;
    // Три компонента >
  PMyBGRPack = ^TMyBGRPack;
  TMyBGRPack = packed record
    B: Byte;
    G: Byte;
    R: Byte;
  end;
    // Массив для перебора  >
  PMyBGRLine = ^TMyBGRLine;
  TMyBGRLine = array [Zero..Zero] of TMyBGRPack;
    // Четыре компонента >
  PMyBGRAPack = ^TMyBGRAPack;
  TMyBGRAPack = packed record
    B: Byte;
    G: Byte;
    R: Byte;
    A: Byte;
  end;
    // Массив для перебора >
  PMyBGRALine = ^TMyBGRALine;
  TMyBGRALine = array [Zero..Zero] of TMyBGRAPack;
//----------------------------------------------------------------------------->
//--------------------------------- Математика :) ----------------------------->
//----------------------------------------------------------------------------->
  PMyVector2f = ^TMyVector2f;
  TMyVector2f = TMy2f; // Двухкомпонентный вектор >
  PMyVector3f = ^TMyVector3f;
  TMyVector3f = TMy3f; // Трёхкомпонентный вектор >
  PMyVector4f = ^TMyVector3f;
  TMyVector4f = TMy4f; // Четырёхкомпонентный вектор >
  PMyMatrix2x2f = ^TMyMatrix2x2f;
  TMyMatrix2x2f = array [_X.._Y,_X.._Y] of Single; // Матрица 4 на 4 >
  PMyMatrix3x3f = ^TMyMatrix3x3f;
  TMyMatrix3x3f = array [_X.._Z,_X.._Z] of Single; // Матрица 3 на 3 >
  PMyMatrix4x4f = ^TMyMatrix4x4f;
  TMyMatrix4x4f = array [_X.._W,_X.._W] of Single; // Матрица 4 на 4 >
//----------------------------------------------------------------------------->
//----------------------------------- Процедуры ------------------------------->
//----------------------------------------------------------------------------->
  PMyProcedure = ^TMyProcedure;
  TMyProcedure = procedure;
  PMyProcedureStd = ^TMyProcedureStd;
  TMyProcedureStd = procedure; stdcall;
  PMyBooleanFunction = ^TMyBooleanFunction;
  TMyBooleanFunction = function: Boolean;
  PMyBooleanFuncStd = ^TMyBooleanFuncStd;
  TMyBooleanFuncStd = function: Boolean; stdcall;
  PMyTHreadedFunction = ^TMyTHreadedFunction;
  TMyTHreadedFunction = function(pData: Pointer): Integer; stdcall;
  PMyFarOnProcessFunc = ^TMyFarOnProcessFunc;
  TMyFarOnProcessFunc = function(CrntState: Pointer): Boolean; stdcall;
//----------------------------------------------------------------------------->
//----------------------------------- Классы ---------------------------------->
//----------------------------------------------------------------------------->
  TMyClass = TObject;
//----------------------------------------------------------------------------->
//------------------------------------ Файлы ---------------------------------->
//----------------------------------------------------------------------------->
  PMySysFile = ^TMySysFile;
  TMySysFile = file;
  TMySysStringFile = file of TMyLongString;
//=============================================================================>
//=------------- "ИГРОВЫЕ" (или просто интересные) СТРУКТУРЫ -----------------=>
//=============================================================================>
  PMyFirstLevelStats = ^TMyFirstLevelStats; // Первичные параметры материала-души >
  TMyFirstLevelStats = record
    Strength: Single;
    Agility: Single;
    Intellect: Single;
    Durability: Single;
  end;
    // Анимешные "настройки"\заголовок >
  PAnimeFilm = ^TAnimeFilm;
  TAnimeFilm = packed record
    Dramma: Byte;
    School: Byte;
    Shonen: Byte;
    Comedy: Byte;
    Psycho: Byte;
    Erotic: Byte;
    Parody: Byte;
    Porno: Byte;
    Adventures: Byte;
    NightMare: Byte;
    Romantic: Byte;
    Aoi: Byte;
    Hentai: Byte;
    Series: Word;
    Length: Word;
    Studio: TMyString64;
    Producer: TMyString64;
    Country: TMyString64;
    Comments: TMyString128;
    Describe: TMyString256;
    PicturePath: TMyString256;
    AnimePath: TMyString256;
  end;
    // Тип описывающий значения содержания разных веществ в еде >
  TMyFCType = Single;
    // Запись параметров пищевой ценности продуктов >
  PMyFoodValue = ^TMyFoodValue;
  TMyFoodValue = packed record
    mProtein: TMyFCType;
    mFat: TMyFCType;
    mCarbohydrates: TMyFCType;
    mCaloria: TMyFCType;
  end;
    // Физические параметры проукта >
  PMyPhisicalParams = ^TMyPhisicalParams;
  TMyPhisicalParams = packed record
    mDensity: TMyFCType;
    mTemperature1: TMyFCType;
    mTemperature2: TMyFCType;
    mTemperature3: TMyFCType;
    mE1: TMyFCType; // Спайность >
    mE2: TMyFCType; // Ковкость >
    mE3: TMyFCType; // Период полураспада >
    mE4: TMyFCType; // Критическая масса >
    mE5: TMyFCType; // Радиус шварцшильда >
    mE6: TMyFCType; // Прочность >
  end;
    // Специальные данные или те, которые ещё не попали в другие категории >
  PMySpecialFoodRecord = ^TMySpecialFoodRecord;
  TMySpecialFoodRecord = packed record
   mCholesterin: TMyFCType;
   mE6: TMyFCType; // Святость >
  end;
    // Полная сумма записей параметров еды >
  PMyFoodType = ^TMyFoodType;
  TMyFoodType = packed record
    mCaption: array [Byte] of Byte; // Название типа еды\пролукты >
    mFoodValue: TMyFoodValue; // Пищевая ценность >
    mVitamins: array [Zero.._127] of array [One.._16] of TMyFCType; // Витамины >
    mFoodAdditivs: array [Zero..M2K] of TMyFCType; // Пищевые добавки >
    mElements: array [Zero.._127] of TMyFCType; // Элементы >
    mE4: TMyFCType; // ГОСТ >
  end;
//=============================================================================>
//=========================== Функциональность модуля =========================>
//=============================================================================>
  procedure DoNothing;
  procedure DoNothingSTD; stdcall;
  procedure FillWithZero(pData: Pointer; Size: Cardinal); overload;
  procedure FillWithZero(var Value: TMy2f); overload;
  procedure FillWithZero(var Value: TMy3f); overload;
  procedure FillWithZero(var Value: TMy4f); overload;
  procedure FillWithOne(pData: PMy4f); overload;
  procedure FillWithOne(pData: PMy3f); overload;
  function ExGetMem(Size: Cardinal): Pointer; stdcall;
  function CreateBuffPack(Size: Cardinal): PMyBuffPack;
  function DestroyBuffPack(var pData: PMyBuffPack): Boolean;
  function CheckSum(pData: Pointer; Size: Cardinal): Word;
  function SupportsSSE: Boolean;
  function SupportsSSE2: Boolean;
  procedure FreeAndClear(var Value: Pointer);
  procedure RandomizeLine(pData: PMyBytes);
  procedure BGRToRGB(pData: PMyBGRLine; Length: Cardinal);
  procedure BGRAToRGBA(pData: PMyBGRALine; Length: Cardinal);
//----------------------------------------------------------------------------->
//----------------------------------- СТРОКИ ---------------------------------->
//----------------------------------------------------------------------------->
  function ClearList(pData: PMyStrings = nil): Boolean;
  function SortStringsInList(pData: PMyStrings  = nil): Boolean;
  function ExchangeStringsInList(Index1,Index2: Cardinal; pData: PMyStrings  = nil): Boolean;
  function AddStringToList(Value: String = EmptyString; pData: PMyStrings  = nil): Boolean;
  function RemoveStringFromList(Index: Cardinal = Zero; pData: PMyStrings = nil; pro: Boolean = true): Boolean;
  function StringIndexInList(Value: String = EmptyString; pData: PMyStrings = nil; UC: Boolean = true): Integer;
  function StrToCardinal(Value: String): Cardinal;
  function ChrToByte(Value: Char): Byte;
  function PCharLength(pData: PChar): Cardinal;
  function PCharDestroy(pData: PChar): Boolean;
  function SetInAppPath(Value: String): String;
  function ExtractFromBreckets(const Value: String): String;
  function IntToStr(Value: Integer): String;
  function StrToInt(const S: string): Integer;
  function UpperCase(Value: String): String;
  function ExtractFilePath(Value: String): String;
  function ExtractFileExt(Value: String): String;
  function ExtractFileName(Value: String): String;
  function ExtractFileNameOnly(Value: String): String;
  function SlashSep(Part1,Part2: String): String;
  function GetExeName: String;
//----------------------------- СОБСТВЕННЫЕ СТРОКИ ---------------------------->
  function MyStringCreate(Value: Cardinal): PMyString; overload;
  function MyStringCreate(const Value: String): PMyString; overload;
  function MyStringCreate(pData: PChar): PMyString; overload;
  function MyStringCreate: PMyString; overload;
  function MyStringMake(pData: PMyString; const Value: String): Boolean; overload;
  function MyStringMake(pData1: PMyString; pData2: PChar): Boolean; overload;
  function MyStringClear(Value: Cardinal): PMyString;
  function MyStringDestroy(pData: PMyString): Boolean;
  function MyStringSize(pData: PMyString): Cardinal;
  function MyStringUsedSize(pData: PMyString): Cardinal;
  function MyStringCreateCopy(pData: PMyString): PMyString;
  function MyStringToString(pData: PMyString): String;
  function MyStringToPChar(pData: PMyString): PChar;
  function MyStringEqual(pData1,pData2: PMyString): Boolean;
  function MyStringSetSize(var pData: PMyString; cSize: Cardinal): Boolean;
  function MyStringElement(pData: PMyString; Index: Cardinal): Byte;
  function MyStringPos(pSourceData,pSearchFragment: PMyString): Integer;
  function MyStringGetPBytePack(pData: PMyString): Pointer;
//----------------------------------------------------------------------------->
//--------------------------------- МАТЕМАТИКА -------------------------------->
//----------------------------------------------------------------------------->
  function PowerOfTen(Value: Cardinal): Cardinal; // Степень десятки >
    // Возвращает истину, с указанной в параметре вероятностью >
  function RandomOf(Value: Cardinal): Boolean;
    // Длинна отрезка (Length of segment) >
  function SegmentLength(var v1,v2: TMyVector2f): Single; overload;
  function SegmentLength(var v1,v2: TMyVector3f): Single; overload;
    // Деление вектора в заданном отношении >
  function VectorDivision(var v1: TMyVector2f; vProportion: Single): TMyVector2f; overload;
  function VectorDivision(var v1: TMyVector3f; vProportion: Single): TMyVector3f; overload;
    // Вычисляем длинну вектора (Length of vector) >
  function VectorLength(var v1: TMyVector2f): Single; overload;
  function VectorLength(var v1: TMyVector3f): Single; overload;
    // Сложение двух векторов (Addition of two vectors) >
  function VectorSum(var v1,v2: TMyVector2f): TMyVector2f; overload;
  function VectorSum(var v1,v2: TMyVector3f): TMyVector3f; overload;
    // Умножение вектора на число (Vector multiplication) >
  function VectorMultiplication(var v1: TMyVector2f; Value: Single): TMyVector2f; overload;
  function VectorMultiplication(var v1: TMyVector3f; Value: Single): TMyVector3f; overload;
    // Нормализация | нормирование (получение вектора единичной длинны) (Normalize) >
  function VectorNormalize(var v1: TMyVector2f): TMyVector2f; overload;
  function VectorNormalize(var v1: TMyVector3f): TMyVector3f; overload;
    // Скалярное произведение двух векторов (scalar multiplication | dot product) >
  function DotProduct(var v1,v2: TMyVector2f): Single; overload;
  function DotProduct(var v1,v2: TMyVector3f): Single; overload;
    // Векторное произведение двух векторов (vector multiplication | cross product) >
  function CrossProduct(var v1,v2: TMyVector3f): TMyVector3f; overload;
    // Площадь треугольника по трём точкам >
  function SquareOfTriangle(var v1,v2,v3: TMyVector2f): Single; overload;
    // Сложение двух матриц (addition) >
  function MatrixSum(var v1,v2: TMyMatrix2x2f): TMyMatrix2x2f; overload;
  function MatrixSum(var v1,v2: TMyMatrix3x3f): TMyMatrix3x3f; overload;
  function MatrixSum(var v1,v2: TMyMatrix4x4f): TMyMatrix4x4f; overload;
    // Умножение матрицы на число (multiplication of matrix by scalar) >
  function MatrixMultiplication(var m1: TMyMatrix2x2f; Value: Single): TMyMatrix2x2f; overload;
  function MatrixMultiplication(var m1: TMyMatrix3x3f; Value: Single): TMyMatrix3x3f; overload;
  function MatrixMultiplication(var m1: TMyMatrix4x4f; Value: Single): TMyMatrix4x4f; overload;
    // Детерминант матрицы (determinant of matrix) >
  function MatrixDeterminant(var m1: TMyMatrix2x2f): Single; overload;
  function MatrixDeterminant(var m1: TMyMatrix3x3f): Single; overload;
//=============================================================================>
//============================= Вторичные константы ===========================>
//=============================================================================>
const
  cMyStringSize = Sizeof(TMyString);
  MyStringUsualLength = _1024-cMyStringSize;
  MyStringUsualSize = _1024;
  cMy2f = SizeOf(TMy2f);
  cMy3f = SizeOf(TMy3f);
  cMy4f = SizeOf(TMy4f);
  cTMyFoodValue: Cardinal = SizeOf(TMyFoodValue);
  cMySpecialFoodRecord: Cardinal = SizeOf(TMySpecialFoodRecord);
  cMyFoodType: Cardinal = SizeOf(TMyFoodType);
//=============================================================================>
//============================= Раздел реализации =============================>
//=============================================================================>
implementation
  // Создать строчку указанной длинны >
function MyStringCreate(Value: Cardinal): PMyString; overload;
begin
GetMem(Pointer(Result),Value+cMyStringSize);
with Result^ do begin
mSize:=Value;
mUsedSize:=Zero; end;
end;
  // Чистая строка нулевой длинны, "занимающая 1-н *кардинал* памяти" >
function MyStringCreate: PMyString; overload;
begin
GetMem(Pointer(Result),MyStringUsualSize);
with Result^ do begin
mSize:=MyStringUsualLength;
mUsedSize:=Zero; end;
end;
  // Создать строчку из переменной типа String >
function MyStringCreate(const Value: String): PMyString; overload;
var a1,a2,a3:Cardinal; p1:PBytePack;
begin
a2:=Length(Value);
if a2 <= MyStringUsualLength then
a3:=MyStringUsualSize else
a3:=a2+cMyStringSize;
GetMem(Pointer(Result),a3);
with Result^ do begin
mSize:=a3-cMyStringSize;
mUsedSize:=a2; end;
if a2 > Zero then begin
p1:=Pointer(Result);
for a1:=One to a2 do
p1^[a1+cMyStringSize-One]:=Byte(Value[a1]); end;
end;
  // Сздать из нультерминальной строки >
function MyStringCreate(pData: PChar): PMyString; overload;
var p1,p2:PBytePack; a1,a2,a3:Cardinal;
begin
if pData = nil then
Result:=nil else begin
p2:=Pointer(pData);
a2:=Zero;
while p2^[a2] <> Zero do
Inc(a2);
if a2 <= MyStringUsualLength then
a3:=MyStringUsualSize else
a3:=a2+cMyStringSize;
GetMem(Pointer(Result),a3);
with Result^ do begin
mSize:=a3-cMyStringSize;
mUsedSize:=a2; end;
p1:=Pointer(Result);
for a1:=Zero to a2 do
p1^[a1+cMyStringSize]:=p2^[a1]; end;
end;
  // Меняет содержимое "строки" >
function MyStringMake(pData1: PMyString; pData2: PChar): Boolean; overload;
var p1,p2:PBytePack; a1,a2,a3:Cardinal;
begin
if pData2 = nil then
Result:=false else
if pData1 = nil then
Result:=false else begin
p2:=Pointer(pData2);
a2:=Zero;
while p2^[a2] <> Zero do
Inc(a2);
if a2 <= MyStringUsualLength then
a3:=MyStringUsualSize else
a3:=a2+cMyStringSize;
with pData1^ do begin
if mSize < a2 then begin
FreeMem(Pointer(pData1),mSize+cMyStringSize);
GetMem(Pointer(pData1),a3); end;
mSize:=a3-cMyStringSize;
mUsedSize:=a2; end;
if a2 > Zero then begin
p1:=Pointer(pData1);
for a1:=Zero to a2-One do
p1^[a1+cMyStringSize]:=p2^[a1]; end;
Result:=true; end;
end;
  // Меняет содержимое "строки" >
function MyStringMake(pData: PMyString; const Value: String): Boolean; overload;
var p1:PBytePack; a1,a2,a3:Cardinal;
begin
if pData = nil then
Result:=false else begin
a2:=Length(Value);
if a2 <= MyStringUsualLength then
a3:=MyStringUsualSize else
a3:=a2+cMyStringSize;
with pData^ do begin
if mSize < a2 then begin
FreeMem(Pointer(pData),mSize+cMyStringSize);
GetMem(Pointer(pData),a3); end;
mSize:=a3-cMyStringSize;
mUsedSize:=a2; end;
if a2 > Zero then begin
p1:=Pointer(pData);
a3:=cMyStringSize-One;
for a1:=One to a2 do
p1^[a1+a3]:=Byte(Value[a1]); end;
Result:=true; end;
end;
  // Возвращает указатель на первый значащий байт, просто пропуская заголовок >
function MyStringGetPBytePack(pData: PMyString): Pointer;
begin
Result:=Pointer(Cardinal(pData)+cMyStringSize);
end;
  // Меняет длинну "строки" >
function MyStringSetSize(var pData: PMyString; cSize: Cardinal): Boolean;
var a1,a3:Cardinal; p1,p2:PBytePack; p3:PMyString;
begin
if pData = nil then begin // Нужно просто создать строку заново >
GetMem(Pointer(pData),cMyStringSize+cSize);
with pData^ do begin
mSize:=cSize;
mUsedSize:=Zero; end;
Result:=true; end else
if pData^.mSize = cSize then // Нужная длинна строки равна имеющейся = всё готово - выходим >
Result:=true else
if cSize = Zero then begin // Нужная длинна строки равна нулю >
FreeMem(Pointer(pData),cMyStringSize+pData^.mSize);
GetMem(Pointer(pData),cMyStringSize+cSize);
with pData^ do begin
mSize:=cSize;
mUsedSize:=Zero; end;
Result:=true; end else
if cSize > pData^.mSize then begin // Нужная длинна строки больше имеющейся >
GetMem(Pointer(p3),cMyStringSize+cSize);
with p3^ do begin
mSize:=cSize;
mUsedSize:=pData^.mUsedSize; end;
p1:=Pointer(pData);
p2:=Pointer(p3);
for a1:=cMyStringSize to cMyStringSize+pData^.mUsedSize-One do
p2^[a1]:=p1^[a1];
FreeMem(Pointer(pData),cMyStringSize+pData^.mSize);
pData:=p3;
Result:=true; end else begin // Нужная длинна строки меньше имеющейся >
GetMem(Pointer(p3),cMyStringSize+cSize);
with p3^ do begin
mSize:=cSize;
mUsedSize:=pData^.mUsedSize; end;
p1:=Pointer(pData);
p2:=Pointer(p3);
if cSize > pData^.mUsedSize then
a3:=pData^.mUsedSize else
a3:=cSize;
for a1:=cMyStringSize to cMyStringSize+a3-One do
p2^[a1]:=p1^[a1];
FreeMem(Pointer(pData),cMyStringSize+pData^.mSize);
pData:=p3;
Result:=true; end;
end;
  // Создать строчку указанной длинны, заполненную нулями >
function MyStringClear(Value: Cardinal): PMyString;
var a1:Cardinal; p1:PBytePack;
begin
GetMem(Pointer(Result),Value+cMyStringSize);
with Result^ do begin
mSize:=Value;
mUsedSize:=Zero; end;
if Value > Zero then begin
p1:=Pointer(Result);
for a1:=cMyStringSize to cMyStringSize+Value-One do
p1^[a1]:=Zero; end;
end;
  // Уничтожить "строчку" >
function MyStringDestroy(pData: PMyString): Boolean;
begin
if pData = nil then
Result:=true else begin
FreeMem(Pointer(pData),pData^.mSize+cMyStringSize);
Result:=true; end;
end;
  // Уничтожить "строчку" >
function MyStringToPChar(pData: PMyString): PChar;
var a1:Cardinal; p1,p2:PBytePack;
begin
if pData = nil then
Result:=nil else
if pData^.mSize = Zero then
Result:=nil else
if pData^.mUsedSize = Zero then
Result:=nil else begin
GetMem(p1,pData^.mUsedSize+cByteSize);
Result:=Pointer(p1);
p2:=Pointer(pData);
for a1:=Zero to pData^.mUsedSize-One do
p1^[a1]:=p2^[a1+cMyStringSize];
p1^[pData^.mUsedSize]:=Zero; end;
end;
  // "Мою строчку" конвертирует в String >
function MyStringToString(pData: PMyString): String;
var a1:Cardinal; p1:PBytePack;
begin
if pData = nil then
Result:=EmptyString else
if pData^.mSize = Zero then
Result:=EmptyString else
if pData^.mUsedSize = Zero then
Result:=EmptyString else begin
p1:=Pointer(pData);
SetLength(Result,pData^.mUsedSize);
for a1:=cMyStringSize to cMyStringSize-One+pData^.mUsedSize do
Result[a1+One-cMyStringSize]:=Char(p1^[a1]); end;
end;
  // Копировать строку >
function MyStringCreateCopy(pData: PMyString): PMyString;
var a1:Cardinal; p1,p2:PBytePack;
begin
if pData = nil then
Result:=nil else begin
GetMem(Pointer(Result),pData^.mSize+cMyStringSize);
Result^.mSize:=pData^.mSize;
Result^.mUsedSize:=pData^.mUsedSize;
if pData^.mSize > Zero then
if pData^.mUsedSize > Zero then begin
p1:=Pointer(Result);
p2:=Pointer(pData);
for a1:=cMyStringSize to pData^.mUsedSize+cMyStringSize-One do
p1^[a1]:=p2^[a1]; end; end;
end;
  // Очистить (нулями заполнить) строчку >
function MyStringMakeClear(pData: PMyString): Boolean;
var a1:Cardinal; p1:PBytePack;
begin
if pData = nil then
Result:=false else
if pData^.mSize = Zero then
Result:=true else begin
p1:=Pointer(pData);
for a1:=cMyStringSize to pData^.mSize+cMyStringSize-One do
p1^[a1]:=Zero;
pData^.mUsedSize:=Zero;
Result:=true; end;
end;
  // Общая длинна строчки >
function MyStringSize(pData: PMyString): Cardinal;
begin
if pData = nil then
Result:=Zero else
Result:=Integer(pData^.mSize);
end;
  // Используемая длинна строчки >
function MyStringUsedSize(pData: PMyString): Cardinal;
begin
if pData = nil then
Result:=Zero else
Result:=Integer(pData^.mUsedSize);
end;
  // Сравнить "на схожесть" пару "моих" строчечек >
function MyStringEqual(pData1,pData2: PMyString): Boolean;
var a1:Cardinal; p1,p2:PBytePack;
begin
if pData1 = nil then
Result:=false else
if pData2 = nil then
Result:=false else
if pData1 = pData2 then
Result:=false else
if pData1^.mUsedSize <> pData2^.mUsedSize then
Result:=false else begin
Result:=true;
p1:=Pointer(pData1);
p2:=Pointer(pData2);
for a1:=cMyStringSize to cMyStringSize+mOne+pData2^.mUsedSize do
if p1^[a1] <> p2^[a1] then begin
Result:=false;
Break; end; end;
end;
  // Индексированный доступ к байтам в "моей строке" >
function MyStringElement(pData: PMyString; Index: Cardinal): Byte;
begin
if pData = nil then
Result:=Zero else
if pData^.mUsedSize > Index then
Result:=PBytePack(Pointer(pData))^[Index+cMyStringSize] else
Result:=Zero;
end;
  // Найти позицию "такого фрагмента" в "моей строке" >
function MyStringPos(pSourceData,pSearchFragment: PMyString): Integer;
var a1,a2,a3:Cardinal; p1,p2:PBytePack;
begin
if pSourceData = nil then
Result:=mOne else
if pSearchFragment = nil then
Result:=mOne else
if pSourceData = pSearchFragment then
Result:=mOne else
if pSourceData^.mUsedSize < pSearchFragment^.mUsedSize then
Result:=mOne else
if pSourceData^.mUsedSize = pSearchFragment^.mUsedSize then begin
p1:=Pointer(pSourceData);
p2:=Pointer(pSearchFragment);
a2:=Zero;
for a1:=cMyStringSize to cMyStringSize-One+pSourceData^.mUsedSize do
if p1^[a1] = p2^[a1] then
Inc(a2) else
Break;
if a2 = pSourceData^.mSize then
Result:=Zero else
Result:=mOne; end else begin
Result:=mOne;
p1:=Pointer(pSourceData);
p2:=Pointer(pSearchFragment);
for a1:=cMyStringSize to cMyStringSize+pSourceData^.mUsedSize-pSearchFragment^.mUsedSize do begin
a3:=Zero;
for a2:=Zero to pSearchFragment^.mUsedSize-One do
if p1^[a1+a2] = p2^[cMyStringSize+a2] then
Inc(a3) else
Break;
if a3 = pSearchFragment^.mUsedSize then begin
Result:=a1-cMyStringSize;
Break; end; end; end;
end;
  // Достаёт строку из скобок >
function ExtractFromBreckets(const Value: String): String;
var a1,a2:Cardinal;
begin
a1:=Pos(mnLeftBrecket,Value);
a2:=Pos(mnRightBrecket,Value);
if (a1 > Zero) and (a2 > Zero) and (a1 < (a2+One)) then
Result:=Copy(Value,a1+One,a2-a1-One) else
Result:=EmptyString;
end;
  // Меняеми местами красный с синим >
procedure BGRToRGB(pData: PMyBGRLine; Length: Cardinal);
var a1:Cardinal; b1:Byte;
begin
for a1:=Zero to Length - One do // Пройтись по картинтке как по одномерному массиву >
with (pData)^[a1] do begin // Так будем представлять компилятору каждый пиксел - три байта >
b1:=R; // Менаяем красный >
R:=B; // и синий >
B:=b1; end; // местами >
end;
  // Меняеми местами красный с синим >
procedure BGRAToRGBA(pData: PMyBGRALine; Length: Cardinal);
var a1:Cardinal; b1:Byte;
begin
for a1:=Zero to Length - One do // Пройтись по картинтке как по одномерному массиву >
with (pData)^[a1] do begin // Так будем представлять компилятору каждый пиксел - три байта >
b1:=R; // Менаяем красный >
R:=B; // и синий >
B:=b1; end; // местами >
end;
  // Поддержка SSE >
function SupportsSSE: Boolean;
var a1:Cardinal;
begin
a1:=One;
asm
push ebx
mov eax,1
db $0F,$A2
test edx,$2000000
jz @NOSSE
mov edx,0
mov a1,edx
@NOSSE:
pop ebx
end;
Result:=a1 = Zero;
end;
  // Поддержка SSE2 >
function SupportsSSE2: Boolean;
var a1:Cardinal;
begin
a1:=One;
asm
push ebx
mov eax,1
db $0F,$A2
test edx,$4000000
jz @NOSSE2
mov edx,0
mov a1,edx
@NOSSE2:
pop ebx
end;
Result:=a1 = Zero;
end;
  // Уничтожение и пометка нулём >
procedure FreeAndClear(var Value: Pointer);
begin
if Value = nil then
Exit else begin
TObject(Value).Destroy;
Value:=nil; end;
end;
  // Переставляет байты в случайном порядке (мешает) >
procedure RandomizeLine(pData: PMyBytes);
var a1,a2:Cardinal; v1:array of byte; b1:Byte;
begin
if pData = nil then begin
GetMem(pData,_256);
for a1:=Zero to ByteMax do
pData^[a1]:=a1; end;
SetLength(v1,_256);
for a1:=ByteMax downto Zero do begin
a2:=Random(a1+One);
v1[a1]:=pData^[a2];
if a2 <> a1 then begin
b1:=pData^[a2];
pData^[a2]:=pData^[a1];
pData^[a1]:=b1; end; end;
for a1:=Zero to ByteMax do
pData^[a1]:=v1[a1];
end;
  // Контрольная сумма >
function CheckSum(pData: Pointer; Size: Cardinal): Word;
var a1,a2:Cardinal;
begin
a2:=Zero;
if Size > Zero then
if Assigned(pData) then
for a1:=Zero to Size-One do
a2:=a2+PBytePack(pData)^[a1];
Result:=Word(a2);
end;
  // Выше-ли первая строка в спике строк? >
function IsFirstUp(var Value1,Value2: String): Boolean;
var a1,a2,a3:cardinal;
begin
a2:=Length(Value1);
a3:=Length(Value2);
if (a2 = Zero) and (a3 <> Zero) then
Result:=true else
if (a3 = Zero) and (a2 <> Zero) then
Result:=false else
if a2 = a3 then begin
Result:=false;
for a1:=One to a2 do
if Byte(Value1[a1]) < Byte(Value2[a1]) then begin
Result:=true;
Break; end else
if Byte(Value1[a1]) > Byte(Value2[a1]) then begin
Result:=false;
Break; end; end else
if a2 > a3 then begin
Result:=false;
for a1:=One to a2 do
if Byte(Value1[a1]) < Byte(Value2[a1]) then begin
Result:=true;
Break; end else
if Byte(Value1[a1]) > Byte(Value2[a1]) then begin
Result:=false;
Break; end; end else begin
Result:=true;
for a1:=One to a3 do
if Byte(Value1[a1]) < Byte(Value2[a1]) then begin
Result:=true;
Break; end else
if Byte(Value1[a1]) > Byte(Value2[a1]) then begin
Result:=false;
Break; end; end;
end;
  // Сортировать список >
function SortStringsInList(pData: PMyStrings  = nil): Boolean;
var a1,a2,a3:Cardinal; s1:String;
begin
if Assigned(pData) then
a2:=Length(pData^) else
a2:=Zero;
if a2 = Zero then
Result:=false else
if a2 = One then
Result:=true else try
for a1:=One to a2-One do
for a3:=a1 to a2-a1 do
if IsFirstUp(pData^[a1],pData^[a1+One]) then begin
s1:=pData^[a1];
pData^[a1]:=pData^[a1+One];
pData^[a1+One]:=s1; end;
Result:=true; except
Result:=false; end;
end;
  // Поменять местами два елемента списка из под таких-то номеров >
function ExchangeStringsInList(Index1,Index2: Cardinal; pData: PMyStrings  = nil): Boolean;
var a2:Cardinal; s1:String;
begin
if Assigned(pData) then
a2:=Length(pData^) else
a2:=Zero;
if a2 = Zero then
Result:=false else
if Index1 >= a2 then
Result:=false else
if Index1 >= a2 then
Result:=false else
if Index1 = Index2 then
Result:=true else begin
s1:=pData^[Index1];
pData^[Index1]:=pData^[Index2];
pData^[Index2]:=s1;
Result:=true; end;
end;
  // Очистить список >
function ClearList(pData: PMyStrings = nil): Boolean;
begin
if Assigned(pData) then begin
SetLength(pData^,Zero);
Result:=true; end else
Result:=false;
end;
  // Найти номер строки в списке >
function StringIndexInList(Value: String = EmptyString; pData: PMyStrings = nil; UC: Boolean = true): Integer;
var a1,a2:Cardinal; s1:String;
begin
Result:= - One;
if Assigned(pData) then
a2:=Length(pData^) else
a2:=Zero;
if a2 > Zero then
if UC then begin
s1:=UpperCase(Value);
for a1:=Zero to a2-One do
if s1 = UpperCase(pData^[a1]) then begin
Result:=a1;
Break; end; end else
for a1:=Zero to a2-One do
if Value = pData^[a1] then begin
Result:=a1;
Break; end;
end;
  // Удаление строкиизсписка по её порядковому номеру >
function RemoveStringFromList(Index: Cardinal = Zero; pData: PMyStrings = nil; pro: Boolean = true): Boolean;
var a1,a2:Cardinal;
begin
if Assigned(pData) then
a2:=Length(pData^) else
a2:=Zero;
if a2 = Zero then
Result:=false else
if Index >= a2 then
Result:=false else
if pro then begin
if Index < (a2-One) then
for a1:=Index to a2-Two do
pData^[a1]:=pData^[a1+One];
SetLength(pData^,a2-One);
Result:=true; end else begin
pData^[Index]:=pData^[a2-One];
SetLength(pData^,a2-One);
Result:=true; end;
end;
  // Добавить строку в список (в самый конец) >
function AddStringToList(Value: String = EmptyString; pData: PMyStrings  = nil): Boolean;
var a1:Cardinal;
begin
if Assigned(pData) then begin
a1:=Length(pData^);
SetLength(pData^,a1+One);
pData^[a1]:=Value;
Result:=true; end else
Result:=false;
end;
  // Создаём "специальный" буффер >
function CreateBuffPack(Size: Cardinal): PMyBuffPack;
begin
if Size = Zero then
Result:=nil else begin
New(Result);
Result^.mSize:=Size;
GetMem(Result^.pData,Size); end;
end;
  // Уничтожаем "специальный" буффер >
function DestroyBuffPack(var pData: PMyBuffPack): Boolean;
begin
if pData = nil then
Result:=true else begin
FreeMem(pData^.pData,pData^.mSize);
Dispose(pData);
Result:=true; end;
end;
  // Дополяет это имя путём к пусковику данной программы >
function SetInAppPath(Value: String): String;
begin
Result:=SlashSep(ExtractFilePath(GetExeName),Value);
end;
  // Возвращает длинну нуль-терминальной строки >
function PCharLength(pData: PChar): Cardinal;
var p1:PCharBuffer; a1:Cardinal;
begin
if Assigned(pData) then begin
p1:=Pointer(pData);
a1:=Zero;
while p1^[a1] <> Zero do
Inc(a1);
Result:=a1; end else
Result:=Zero;
end;
  // Уничтожает нуль-терминальную строку >
function PCharDestroy(pData: PChar): Boolean;
var p1:PCharBuffer; a1:Cardinal;
begin
if pData = nil then
Result:=true else begin
p1:=Pointer(pData);
a1:=Zero;
while p1^[a1] <> Zero do
Inc(a1);
FreeMem(pData,a1+One);
Result:=true; end;
end;
  // Знак в целое число >
function ChrToByte(Value: Char): Byte;
begin
case Value of
'0': Result:=Zero;
'1': Result:=One;
'2': Result:=Two;
'3': Result:=Three;
'4': Result:=Four;
'5': Result:=Five;
'6': Result:=Six;
'7': Result:=Seven;
'8': Result:=Eight;
'9': Result:=Nine;
else Result:=Zero; end;
end;
  // Строку в целое число >
function StrToCardinal(Value: String): Cardinal;
var a1,a2:Cardinal;
begin
a2:=Length(Value);
if a2 = Zero then
Result:=Zero else
if a2 = One then
Result:=ChrToByte(Value[One]) else begin
Result:=ChrToByte(Value[One]);
for a1:=Two to a2 do
Result:=Result+ChrToByte(Value[a1])*PowerOfTen(a1-One); end;
end;
  // Експорт собственной памяти >
function ExGetMem(Size: Cardinal): Pointer; stdcall;
begin
GetMem(Result,Size);
end;
  // Заполняем константами >
procedure FillWithOne(pData: PMy4f);
var a1:Cardinal;
begin
for a1:=Zero to Three do
pData^[a1]:=One;
end;
  // Заполняем константами >
procedure FillWithOne(pData: PMy3f);
var a1:Cardinal;
begin
for a1:=Zero to Two do
pData^[a1]:=One;
end;
  // Обнулить эту память >
procedure FillWithZero(pData: Pointer; Size: Cardinal);
begin
FillChar(pData^,Size,Zero);
end;
  // 2f >
procedure FillWithZero(var Value: TMy2f);
begin
FillChar(Value,cMy2f,Zero);
end;
  // 3f >
procedure FillWithZero(var Value: TMy3f);
begin
FillChar(Value,cMy3f,Zero);
end;
  // 4f >
procedure FillWithZero(var Value: TMy4f);
begin
FillChar(Value,cMy4f,Zero);
end;
  // Возвращает имя пускателя >
function GetExeName: String;
begin
Result:=ParamStr(Zero);
end;
  // Это еще пригодится не только сдесь, в этом модуле >
procedure DoNothing;
begin
{Пусто}
end;
  // Так-же но не совсем >
procedure DoNothingSTD; stdcall;
begin
{Пусто}
end;
  // Разделяет две строчки "слЭшом", если надо >
function SlashSep(Part1,Part2: String): String;
begin
if Part1[Length(Part1)] <> mnSlash then
Result:=Part1 + mnSlash + Part2 else
Result:=Part1 + Part2;
end;
  // Извлечь из адреса путь к файлу >
function ExtractFilePath(Value: String): String;
var a1:Integer;
begin
a1:=Length(Value);
if a1 > Zero then
while (Value[a1] <> mnSlash) and (Value[a1] <> mnBeckSlash) and (a1 <> Zero) do
Dec(a1);
if a1 < One then
Result:=Value else
Result:=Copy(Value,One,a1);
end;
  // Извлечь разрешение файла >
function ExtractFileExt(Value: String): String;
var a1,a2:Cardinal; s1,s2:String;
begin
s1:=EmptyString;
a1:=Length(Value);
for a2:=a1 downto One do
s1:=s1+Value[a2];
a1:=Pos(mnDot,s1);
s1:=Copy(s1,One,a1-One);
s2:=EmptyString;
a1:=Length(s1);
for a2:=a1 downto One do
s2:=s2+s1[a2];
Result:=s2;
end;
  // Извлечь из адреса имя файла >
function ExtractFileName(Value: String): String;
var a1,a2:Integer;
begin
a2:=Length(Value);
a1:=a2;
if a1 > Zero then
while (Value[a1] <> mnSlash) and (Value[a1] <> mnBeckSlash) and (a1 > Zero) do
Dec(a1);
if a1 > Zero then
Result:=Copy(Value,a1 + One,a2 - a1) else
Result:=EmptyString;
end;
  // Извлечь из адреса само имя файла без расширения и пути >
function ExtractFileNameOnly(Value: String): String;
var a1,a2,a3:Integer;
begin
Result:=EmptyString;
a3:=Length(Value);
a2:=a3;
if a3 > Zero then begin
a1:=a3;
while (Value[a1] <> mnDot) and (a1 >= Zero) do
Dec(a1);
if a1 > One then
a2:=a1;
while (Value[a2] <> mnSlash) and (Value[a2] <> mnBeckSlash) and (a2 >= Zero) do
Dec(a2);
if (a1 < One) and (a2 < One) then
Result:=Value else
if (a1 < One) and (a2 > Zero) then
Result:=Copy(Value,a2 + One,a3 - a2) else
if (a1 > Zero) and (a2 < One) then
Result:=Copy(Value,One,a1 - One) else
if (a1 > Zero) and (a2 > Zero) and (a1 > a2) then
Result:=Copy(Value,a2 + One,a1 - a2 - One); end;
end;
  // Вместо того, что в SysUtils >
function IntToStr(Value: Integer): String;
begin
Str(Value,Result);
end;
  // Ещё одна подстава ;) >
function StrToInt(const S: string): Integer;
var a1: Integer;
begin
Val(S,Result,a1);
if a1 <> Zero then
Result:=Zero;
end;
  // "Мелкие" буквы в "большие" >
function UpperCase(Value: String): String;
var a1,a2:Cardinal;
begin
a2:=Length(Value);
if a2 = Zero then
Result:=EmptyString else begin
SetLength(Result,a2);
for a1:=One to a2 do
case Byte(Value[a1]) of
One..127:   Result[a1]:=UpCase(Value[a1]);
$E0..$FF: Result[a1]:=Chr(byte(Value[a1]) - _32);
$B3:      Result[a1]:=Chr($B2); // Украинские символы >
$BF:      Result[a1]:=Chr($AF);
$B4:      Result[a1]:=Chr($A5);
$B8:      Result[a1]:=Chr($A8); // буква ё >
else      Result[a1]:=Value[a1]; end; end;
end;
//=============================================================================>
//================================ МАТЕМАТИКА =================================>
//=============================================================================>
function PowerOfTen(Value: Cardinal): Cardinal;
var a1:Cardinal;
begin // Степень десятки >
if Value = Zero then
Result:=One else begin
Result:=One;
for a1:=One to Value do
Result:=Result*Ten; end;
end;
  // Возвращает истину, с указанной в параметре вероятностью >
function RandomOf(Value: Cardinal): Boolean;
begin
if Value = Zero then
Result:=true else
Result:=Random(Value) = Zero;
end;
//=============================================================================>
//================================= ВЕКТОРЫ ===================================>
//=============================================================================>
function SegmentLength(var v1,v2: TMyVector2f): Single; // 2f >
begin // Вычисляем длинну отрезка (Length of segment) >
Result:=Sqrt(Sqr(v2[_X]-v1[_X])+Sqr(v2[_Y]-v1[_Y]));
end;
  // 3f >
function SegmentLength(var v1,v2: TMyVector3f): Single;
begin // Вычисляем длинну отрезка (Length of segment) >
Result:=Sqrt(Sqr(v2[_X]-v1[_X])+Sqr(v2[_Y]-v1[_Y])+Sqr(v2[_Z]-v1[_Z]));
end;
  // Деление вектора в заданном отношении >
function VectorDivision(var v1: TMyVector2f; vProportion: Single): TMyVector2f;
begin // 2f >
Result[_X]:=v1[_X]*vProportion/(One+vProportion);
Result[_Y]:=v1[_Y]*vProportion/(One+vProportion);
end;
  // 3f >
function VectorDivision(var v1: TMyVector3f; vProportion: Single): TMyVector3f;
begin
Result[_X]:=v1[_X]*vProportion/(One+vProportion);
Result[_Y]:=v1[_Y]*vProportion/(One+vProportion);
Result[_Z]:=v1[_Z]*vProportion/(One+vProportion);
end;
  // Вычисляем длинну вектора (Length of vector) >
function VectorLength(var v1: TMyVector2f): Single;
begin // 2f >
Result:=Sqrt(Sqr(v1[_X])+Sqr(v1[_Y]));
end;
  // 3f >
function VectorLength(var v1: TMyVector3f): Single;
begin
Result:=Sqrt(Sqr(v1[_X])+Sqr(v1[_Y])+Sqr(v1[_Z]));
end;
  // Сложение двух векторов (Addition of two vectors) >
function VectorSum(var v1,v2: TMyVector2f): TMyVector2f;
begin // 2f >
Result[_X]:=v1[_X]+v2[_X];
Result[_Y]:=v1[_Y]+v2[_Y];
end;
  // 3f >
function VectorSum(var v1,v2: TMyVector3f): TMyVector3f;
begin
Result[_X]:=v1[_X]+v2[_X];
Result[_Y]:=v1[_Y]+v2[_Y];
Result[_Z]:=v1[_Z]+v2[_Z];
end;
  // Умножение вектора на число (Vector multiplication) >
function VectorMultiplication(var v1: TMyVector2f; Value: Single): TMyVector2f;
begin // 2f >
Result[_X]:=v1[_X]*Value;
Result[_Y]:=v1[_Y]*Value;
end;
  // 3f >
function VectorMultiplication(var v1: TMyVector3f; Value: Single): TMyVector3f;
begin
Result[_X]:=v1[_X]*Value;
Result[_Y]:=v1[_Y]*Value;
Result[_Z]:=v1[_Z]*Value;
end;
  // Нормализация | нормирование (получение вектора единичной длинны) (Normalize) >
function VectorNormalize(var v1: TMyVector2f): TMyVector2f;
var vL:Single;
begin // 2f >
vL:=One/Sqrt(Sqr(v1[_X])+Sqr(v1[_Y]));
Result[_X]:=v1[_X]*vL;
Result[_Y]:=v1[_Y]*vL;
end;
  // 3f >
function VectorNormalize(var v1: TMyVector3f): TMyVector3f;
var vL:Single;
begin
vL:=One/Sqrt(Sqr(v1[_X])+Sqr(v1[_Y])+Sqr(v1[_Z]));
Result[_X]:=v1[_X]*vL;
Result[_Y]:=v1[_Y]*vL;
Result[_Z]:=v1[_Z]*vL;
end;
  // Скалярное произведение двух векторов (scalar multiplication | dot product) >
function DotProduct(var v1,v2: TMyVector2f): Single;
begin // 2f >
Result:=v1[_X]*v2[_X]+v1[_Y]*v2[_Y];
end;
  // 3f >
function DotProduct(var v1,v2: TMyVector3f): Single;
begin
Result:=v1[_X]*v2[_X]+v1[_Y]*v2[_Y]+v1[_Z]*v2[_Z];
end;
  // Векторное произведение двух векторов (vector multiplication | cross product) >
function CrossProduct(var v1,v2: TMyVector3f): TMyVector3f;
begin
Result[_X]:=v1[_Y]*v2[_Z]-v1[_Z]*v2[_Y];
Result[_Y]:=v1[_Z]*v2[_X]-v1[_X]*v2[_Z];
Result[_Z]:=v1[_X]*v2[_Y]-v1[_Y]*v2[_X];
end;
  // Площадь треугольника по трём точкам >
function SquareOfTriangle(var v1,v2,v3: TMyVector2f): Single;
begin
Result:=((v2[_X]-v1[_X])*(v3[_Y]-v1[_Y])-(v2[_Y]-v1[_Y])*(v3[_X]-v1[_X]))/_2;
end;
//=============================================================================>
//================================= МАТРИЦЫ ===================================>
//=============================================================================>
function MatrixSum(var v1,v2: TMyMatrix2x2f): TMyMatrix2x2f;
begin // [2x2] Сложение двух матриц (addition) >
Result[_X,_X]:=v1[_X,_X]+v2[_X,_X];
Result[_X,_Y]:=v1[_X,_Y]+v2[_X,_Y];
Result[_Y,_X]:=v1[_Y,_X]+v2[_Y,_X];
Result[_Y,_Y]:=v1[_Y,_Y]+v2[_Y,_Y];
end;
  // [3x3] >
function MatrixSum(var v1,v2: TMyMatrix3x3f): TMyMatrix3x3f;
begin
Result[_X,_X]:=v1[_X,_X]+v2[_X,_X];
Result[_X,_Y]:=v1[_X,_Y]+v2[_X,_Y];
Result[_X,_Z]:=v1[_X,_Z]+v2[_X,_Z];
Result[_Y,_X]:=v1[_Y,_X]+v2[_Y,_X];
Result[_Y,_Y]:=v1[_Y,_Y]+v2[_Y,_Y];
Result[_Y,_Z]:=v1[_Y,_Z]+v2[_Y,_Z];
Result[_Z,_X]:=v1[_Z,_X]+v2[_Z,_X];
Result[_Z,_Y]:=v1[_Z,_Y]+v2[_Z,_Y];
Result[_Z,_Z]:=v1[_Z,_Z]+v2[_Z,_Z];
end;
  // [4x4] >
function MatrixSum(var v1,v2: TMyMatrix4x4f): TMyMatrix4x4f;
begin
Result[_X,_X]:=v1[_X,_X]+v2[_X,_X];
Result[_X,_Y]:=v1[_X,_Y]+v2[_X,_Y];
Result[_X,_Z]:=v1[_X,_Z]+v2[_X,_Z];
Result[_X,_W]:=v1[_X,_W]+v2[_X,_W];
Result[_Y,_X]:=v1[_Y,_X]+v2[_Y,_X];
Result[_Y,_Y]:=v1[_Y,_Y]+v2[_Y,_Y];
Result[_Y,_Z]:=v1[_Y,_Z]+v2[_Y,_Z];
Result[_Y,_W]:=v1[_Y,_W]+v2[_Y,_W];
Result[_Z,_X]:=v1[_Z,_X]+v2[_Z,_X];
Result[_Z,_Y]:=v1[_Z,_Y]+v2[_Z,_Y];
Result[_Z,_Z]:=v1[_Z,_Z]+v2[_Z,_Z];
Result[_Z,_W]:=v1[_Z,_W]+v2[_Z,_W];
Result[_W,_X]:=v1[_W,_X]+v2[_W,_X];
Result[_W,_Y]:=v1[_W,_Y]+v2[_W,_Y];
Result[_W,_Z]:=v1[_W,_Z]+v2[_W,_Z];
Result[_W,_W]:=v1[_W,_W]+v2[_W,_W];
end;
  // [2x2] Умножение матрицы на число (multiplication of matrix by scalar) >
function MatrixMultiplication(var m1: TMyMatrix2x2f; Value: Single): TMyMatrix2x2f;
begin
Result[_X,_X]:=m1[_X,_X]*Value;
Result[_X,_Y]:=m1[_X,_Y]*Value;
Result[_Y,_X]:=m1[_Y,_X]*Value;
Result[_Y,_Y]:=m1[_Y,_Y]*Value;
end;
  // [3x3] >
function MatrixMultiplication(var m1: TMyMatrix3x3f; Value: Single): TMyMatrix3x3f;
begin
Result[_X,_X]:=m1[_X,_X]*Value;
Result[_X,_Y]:=m1[_X,_Y]*Value;
Result[_X,_Z]:=m1[_X,_Z]*Value;
Result[_Y,_X]:=m1[_Y,_X]*Value;
Result[_Y,_Y]:=m1[_Y,_Y]*Value;
Result[_Y,_Z]:=m1[_Y,_Z]*Value;
Result[_Z,_X]:=m1[_Z,_X]*Value;
Result[_Z,_Y]:=m1[_Z,_Y]*Value;
Result[_Z,_Z]:=m1[_Z,_Z]*Value;
end;
  // [4x4] >
function MatrixMultiplication(var m1: TMyMatrix4x4f; Value: Single): TMyMatrix4x4f;
begin
Result[_X,_X]:=m1[_X,_X]*Value;
Result[_X,_Y]:=m1[_X,_Y]*Value;
Result[_X,_Z]:=m1[_X,_Z]*Value;
Result[_X,_W]:=m1[_X,_W]*Value;
Result[_Y,_X]:=m1[_Y,_X]*Value;
Result[_Y,_Y]:=m1[_Y,_Y]*Value;
Result[_Y,_Z]:=m1[_Y,_Z]*Value;
Result[_Y,_W]:=m1[_Y,_W]*Value;
Result[_Z,_X]:=m1[_Z,_X]*Value;
Result[_Z,_Y]:=m1[_Z,_Y]*Value;
Result[_Z,_Z]:=m1[_Z,_Z]*Value;
Result[_Z,_W]:=m1[_Z,_W]*Value;
Result[_W,_X]:=m1[_W,_X]*Value;
Result[_W,_Y]:=m1[_W,_Y]*Value;
Result[_W,_Z]:=m1[_W,_Z]*Value;
Result[_W,_W]:=m1[_W,_W]*Value;
end;
  // [2x2] Детерминант матрицы (determinant of matrix) >
function MatrixDeterminant(var m1: TMyMatrix2x2f): Single; 
begin
Result:=m1[_0,_0]*m1[_1,_1]-m1[_0,_1]*m1[_1,_0];
end;
  // [3x3] >
function MatrixDeterminant(var m1: TMyMatrix3x3f): Single;
begin
Result:=m1[_0,_0]*(m1[_1,_1]*m1[_2,_2]-m1[_2,_1]*m1[_1,_2])-m1[_0,_1]*(m1[_1,_0]*m1[_2,_2]-m1[_1,_2]*m1[_2,_0])+m1[_0,_2]*(m1[_1,_0]*m1[_2,_1]-m1[_2,_0]*m1[_1,_1]);
end;
//=============================================================================>
//================================= Конец модуля ==============================>
//=============================================================================>
end.
