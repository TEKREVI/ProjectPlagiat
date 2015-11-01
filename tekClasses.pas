{===============================================================================
Зависимый от "Windows" модуль с незначительной инициализацией, обеспечивает
"основными" классами, являясь миниБиблиотекой-опорой.
Источник: kernel32.dll,user32,advapi32.dll и тому подобные "обязательные штуки",
которые я тем не менее хочу перечислить в "списке зависимости"
===============================================================================}
unit tekClasses; // 2012.3.22 TEK (www.TEK.86@Mail.ru) >
//=============================================================================>
//=============================== Раздел обьявлений ===========================>
//=============================================================================>
interface
  // Только независимые или Windows-зависимые модули! >
uses tekSystem,Windows,Messages,TLHelp32;
//=============================================================================>
//==================================== Типы ===================================>
//=============================================================================>
type
    // Для колупания в системных функциях >
  PMyParamString = ^TMyParamString;
  TMyParamString = array [Zero..MAX_PATH-One] of Char;
    // Это для параметров типа lpAnsiChar >
  PMySystemPath = PMyParamString;
  TMySystemPath = TMyParamString;
    // Заимствовано из SysUtils >
  PLPack = ^TLPack; // Для дальнейшего расширения в Сишном ванианте 8) - универсальность! >
  TLPack = packed record
    case Integer of
      Zero:(Lo,Hi: Word);
      One:(Words: array [Zero..One] of Word);
      Three:(Bytes: array [Zero..Three] of Byte);
  end;
    // Местное название >
  LongRec = TLPack;
    // Расширяемость, - возможно 8) >
  PSearchRec = ^TSearchRec;
  TSearchRec = record // Заимствовано из SysUtils >
    Time: Integer;
    Size: Integer;
    Attr: Cardinal;
    Name: String;
    ExcludeAttr: Cardinal;
    FindHandle: Cardinal;
    FindData: TWin32FindData;
  end;
    // Тип процедуры обработчика оконных сообщений от Windows >
  PWindowProc = ^TWindowProc;
  TWindowProc = function(hWnd,uMsg: Cardinal; wParam,lParam: Integer): Integer; stdcall;
    // Великий класс-предшественник ;) >
  TMyParent = class
    constructor Create(Value: Pointer = nil);
    destructor Destroy; override;
  private // Скрытая часть >
    pClrVar: Pointer;
    pProperties: Pointer;
    mName: String;
    mType: Cardinal;
  public // Открытая часть >
    property Name: String read mName write mName;
    property MyType: Cardinal read mType write mType;
    property Properties: Pointer read pProperties write pProperties;
    property ClearValue: Pointer read pClrVar write pClrVar;
  end;
    // Поток (в смысле паралельный поток команд процесcору) >
  TMyThread = class(TMyParent)
    constructor Create;
    destructor Destroy; override;
  private // Скрытая часть >
    mThreadID: Cardinal;
    mStop: Boolean;
    procedure SetPriority(Value: Integer);
    function GetPriority: Integer;
  public // Открытая часть >
    property Stop: Boolean read mStop write mStop;
    property Priority: Integer read GetPriority write SetPriority;
    function OnTreadProcLine: Cardinal;
  end;
    // Настройки для "однопроходного режима" записи большинства параметров "узла" >
  PMyNodePack = ^TMyNodePack;
  TMyNodePack = packed record
    mCreate: TMyTime; // Время создания >
    mView: TMyTime; // Время последнего просмотра >
    mEdit: TMyTime; // Время последнего изменения >
    mContainerType: Cardinal; // Дополнительная информация про контейнер, "тип контейнера" >
    mCount: Cardinal; // Количество элементов в списке дочерних узлов >
    mHigh: Integer; // Номер последнего элемента в списке дочерних узлов >
    mCap: Cardinal; // Ёмкость списка дочерних узлов >
    mNumber: Integer; // Собственный порядковый номер в родительском списке узлов >
  end;
    // "Узел" >
  TMyNode = class(TMyParent) // "Более подробный узел", приспособленный для пользователя >
    constructor Create; overload;
    destructor Destroy; override;
    destructor DestroyAll;
  private // Скрытая часть >
    mItems: array of TMyNode; // Список дочерних узлов >
    mParent: TMyNode; // Указатель на родительский узел >
    pContainer: Pointer; // Указатель для передачи некоторой ссылки среди всех дочерних узлов >
    pPreContainer: Pointer; // Указатель на указатель на содержимое контейнера >
    pCreate: PMyTime; // Время создания >
    pView: PMyTime; // Время последнего просмотра >
    pEdit: PMyTime; // Время последнего изменения >
    mIPack: TMyNodePack; // Пакован настроек >
    pIPack: PMyNodePack; // Указатель на пакован >
    function GetItem(Index: Cardinal): TMyNode;
    function SetCount(Value: Cardinal): Boolean;
    function GetCountAll: Cardinal;
    function GetFirst: TMyNode;
    function GetLast: TMyNode;
    function GetFullName: String;
    function GetFullPPath: PChar;
    procedure SpreadContainer;
  public // "Открытая" часть >
    property Number: Integer read mIPack.mNumber;
    property Parent: TMyNode read mParent;
    property Count: Cardinal read mIPack.mCount;
    property CountAll: Cardinal read GetCountAll;
    property Capasity: Cardinal read mIPack.mCap;
    property Items[Index: Cardinal]: TMyNode read GetItem;
    property Max: Integer read mIPack.mHigh;
    property First: TMyNode read GetFirst;
    property Last: TMyNode read GetLast;
    property Container: Pointer read pContainer;
    property ContainerType: Cardinal read mIPack.mContainerType;
    property PreContainer: Pointer read pPreContainer;
    property FullName: String read GetFullName;
    property FullPath: PChar read GetFullPPath;
    property CreateTime: PMyTime read pCreate;
    property EditTime: PMyTime read pEdit;
    property ViewTime: PMyTime read pView;
    function Add: TMyNode; overload;
    function Add(Value: TMyNode): Boolean; overload;
    function Remove(Index: Cardinal): Boolean;
    function Clear: Boolean;
    function ClearDestroy: Boolean;
    function ClearDestroyAll: Boolean;
    function SetContainer(pData: Pointer = nil; cType: Cardinal = Zero): Boolean;
    procedure Compress;
    procedure UpDateViewTime; // Обновить время просмотра >
    procedure UpDateEditTime; // Обновить время редакции >
  end;
    // "Поток памяти" => "буффер в оперативке" для скоростной обработки >
  TMyMemoryStream = class(TMyParent)
    constructor Create; // Консруктор >
    destructor Destroy; override; // Деструктор >
  private // Вспомогательная часть >
    pBuffer: Pointer; // Указатель на буффер >
    pPreBuffer: Pointer; // Указатель на укзатель на буффер >
    mBufferSize: Cardinal; // Размеры буффера >
    mBufferUsed: Cardinal; // сколько байт в буффере используется >
    function GetBufferString: String; // Пытается превратить содержимое буффера в строку и вернуть результатом %) >
    procedure SetBufferUsed(Value: Cardinal); // Установить, сколько буффера сейчас активно >
    procedure SetBufferString(Value: String); // Записывает из строки в буффер >
  public // "Настоящая функциональность" >
    property Buffer: Pointer read pBuffer; // Буффер >
    property PreBuffer: Pointer read pPreBuffer; // Указатель на буффер >
    property BufferSize: Cardinal read mBufferSize; // Полный размер буфера >
    property BufferUsed: Cardinal read mBufferUsed write SetBufferUsed; // Использовано байт буффера >
    property BufferString: String read GetBufferString write SetBufferString; // Возвращает содержимое буффера в вибе строки типа String >
    function ActivateBuffer: Boolean; // Пометить весь буффер, как активный >
    function ClearBuffer: Boolean; // Заполнить память буффера нулями >
    function TakeFromBuffer(Size: Cardinal): Boolean; // Удалить из буффера столько-то байт, с таким-то сдвигом, после чего скопированная часть удаляется >
    function ExpandBufferFor(Size: Cardinal): Boolean; // Расширить буффер нa Size количество байт >
    function ExpandBufferUntil(Size: Cardinal): Boolean; // Расширить буффер до Size количество байт >
    function CopyToBuffer(pData: Pointer; Size: Cardinal): Boolean; // Скопировать в буффер данные, в случае нехватки памяти, он расширится сам >
    function CopyFromBuffer(pData: Pointer; Size: Cardinal): Boolean; // Скопировать данные избуффера куда-то >
    function ReSizeBuffer(Size: Cardinal): Boolean; // Переразметить буффер с сохранением "не использованных" данных >
    function ReBuildBuffer(Size: Cardinal): Boolean; // Пересоздать буффер без сохранения чего-бы-то-ни-было, что там было раньше >
    function DestroyBuffer: Boolean; // Освободить память из буффера >
  end;
    // Класс-файл надстройка над "Windows API" >
  TMyFileStream = class(TMyMemoryStream)
    constructor Create; // Консруктор >
    destructor Destroy; override; // Деструктор >
  private // Вспомогательная часть >
    mHandle: Cardinal; // Файловый дескриптор >
    mPath: String; // Путь к файлу >
    mMapping: Cardinal; // Дескриптор отображения файла в память >
    mSystemGranularity: Cardinal; // Системная "гранулярность": величина, которой кратны страницы распределения\выдачи памяти >
    pBasePointer: Pointer; // Адрес полученного отображения файла в адресное пространство процесса >
    pCrntPointer: Pointer; // "Искомый адрес" в отображении >
    function GetPos: Int64; // Возвращает текущуюю позицию в файле (до и после 4гб)>
    procedure SetPos(Value: Int64); // Устанавливает текущую позицию в файле (до и после 4гб) >
    function GetSize: Int64; // Возвращает размеры файла (до и после 4гб) >
    procedure SetSize(Value: Int64); // Установить рамер файла >
    function GetPCharFilePath: PChar; // PChar-"преобразование" >
  public // "Настоящая функциональность" >
    property FilePath: String read mPath; // Путь к файлу, который связан/открыт >
    property pFilePath: PChar read GetPCharFilePath; // PChar-вариант "путь к файлу" >
    property Position: Int64 read GetPos write SetPos; // Позиция чтения/записи в файле >
    property Size: Int64 read GetSize write SetSize; // Размер файла >
    property Handle: Cardinal read mHandle; // Дискриптор ОС файла >
    property Mapping: Cardinal read mMapping;
    property SystemGranularity: Cardinal read mSystemGranularity;
    property BaseMapPointer: Pointer read pBasePointer;
    property CrntMapPointer: Pointer read pCrntPointer;
    function OpenRead(Path: String): Boolean; // Открыть файл для чтения >
    function OpenWrite(Path: String): Boolean; // Открыть файл для записи >
    function CreateWrite(Path: String): Boolean; // Создать файл для записи >
    function OpenReadWrite(Path: String): Boolean; // Открыть файл для чтения и записи, а если его нет, то попытаться его создать >
    function CreateMapping(cSize: Int64 = Zero): Boolean; // Создать "объект отображения", в 64х-битной адрессации >
    function UnMap: Boolean; // Убить "объект-отображение" >
    function CreateView(cPosition,cCount: Int64): Boolean; // Отобразить "объект в память", в 64х-битной адрессации  >
    function UnView: Boolean; // Уничтожить отображение в память >
    function MapView(cPosition,cCount: Int64): Boolean; // Создать объект отображения и отобразить его, в один вызов >
    function UnViewMap: Boolean; // "Развидеть" отображенный объект Х-) >
    function Close: Boolean; // Закрыть доступ к файлу >
    function CloseFull: Boolean; // Закрыть доступ к файлу >
    function Delete: Boolean; // Удалить этот файл >
    function Copy(Value: String; OverWrite: Boolean = false): Boolean; // Копировать по указанному адресу >
    function Check: Boolean; // Проверка ликвидности дискриптора >
    function EndOfFile: Boolean; // Возвращает true если мы сейчас находимся в конце файла >
    function SetEndHere: Boolean; // Устанавливает конец файла в текущую позицию >
    function GoToBegin: Boolean; // Сдвинуться на начало файла (в нулевую позицию) >
    function GoToEnd: Boolean; // Сдвинуться на последнюю позицию в файле >
    function SimilarTo(Value: TMyFileStream; cLength: Cardinal = mnKB): Cardinal; // Проверка на сходство двух файлов, по расположению, размеру, содержимому,.. >
    function ReadAll: Boolean; overload; // Прочитать весь файл в буффер >
    function ReadLn(var Value: String): Boolean; overload; // Прочитать строчку (для текстовых файлов) >
    function ReadLn(var pData: PMyString): Boolean; overload;
    function ReadAdd(Size: Cardinal): Boolean; // Прочитать, дописав полученные данные в буффер, который при необходимости расширится >
    function Read: Boolean; overload; // Прочитать в буффер столько данных, каков его(буффера) полный объём >
    function Read(var Value; Size: Cardinal): Boolean; overload;
    function Read(var pData: Pointer; Size: Cardinal): Boolean; overload;
    function Read(var Value: String): Boolean; overload;
    function Read(var pData: PMyString): Boolean; overload;
    function Read(var pData: PChar): Boolean; overload;
    function Read(var Value: Cardinal): Boolean; overload; // Целое >
    function Read(var Value: Integer): Boolean; overload; // Действительное >
    function Read(var Value: Word): Boolean; overload; // Слово >
    function Read(var Value: Byte): Boolean; overload; // Байт >
    function Read(var Value: Boolean): Boolean; overload; // Булево >
    function Read(var Value: Single): Boolean; overload; // Вещественное >
    function Read(var Value: Int64): Boolean; overload;
    function Read(var Value; nSize: Cardinal; nPosition: Int64): Boolean; overload;
    function ReadString: String;
    function ReadCardinal: Cardinal;
    function WriteLn(const Value: String): Boolean; // Записать строку (для текстовых файлов) >
    function Write: Boolean; overload; // Записать всё, что в буффере в файл >
    function Write(var Value; Size: Cardinal): Boolean; overload;
    function Write(pData: Pointer; Size: Cardinal): Boolean; overload;
    function Write(const Value: String): Boolean; overload;
    function Write(const pData: PMyString): Boolean; overload;
    function Write(var pData: PChar): Boolean; overload;
    function Write(var Value: Cardinal): Boolean; overload; // Целое >
    function Write(var Value: Integer): Boolean; overload; // Действительное >
    function Write(var Value: Word): Boolean; overload; // Слово >
    function Write(var Value: Byte): Boolean; overload; // Байт >
    function Write(var Value: Boolean): Boolean; overload; // Булево >
    function Write(var Value: Single): Boolean; overload; // Вещественное >
    function Write(var Value: Int64): Boolean; overload;
    function Write(var Value; nSize: Cardinal; nPosition: Int64): Boolean; overload;
    function WriteCardinal(Value: Cardinal): Boolean;
  end;
    // WAV заголовок >
  PMyWAVHeader = ^TMyWAVHeader;
  TMyWAVHeader = packed record
    ChunkID: TMy4Char; // "RIFF" Заголовок
    ChunkSize: Cardinal; // Размер файла минус текущая позиция (минус восемь) >
    Format: TMy4Char; // "WAVE" ещё один заголовок >
    SubChunk1ID: TMy4Char; // "fmt " подзаголовок "куска" >
    SubChunk1Size: Cardinal; // 16 for PCM.  This is the size of the rest of the Subchunk which follows this number. >
    AudioFormat: Word; // PCM = 1 (несжатый = 1) >
    NumChannels: Word; // Количество каналов: Моно = 1, Стерео = 2 и т.д. >
    SampleRate: Cardinal; // Частота: 8000, 44100 и т.д. >
    ByteRate: Cardinal; // ByteRate = SampleRate*NumChannels*BitsPerSample/8 >
    BlockAlign: Word; // BlockAlign = NumChannels*BitsPerSample/8 >
    BitsPerSample: Word; // 8 bits = 8, 16 bits = 16, etc. >
    SubChunk2ID: TMy4Char; // "data" подзаголовок для последнего "куска" за которым уже хранятся звуковые данные >
    SubChunk2Size: Cardinal; // Размер звуковых данных (SubChunk2Size = SampleRate*NumChannels*BitsPerSample/8) >
  end;
    // Файловый поток для WAV-файлов >
  TMyWAVStream = class(TMyFileStream)
    constructor Create;
    destructor Destroy; override;
  private // "Механика" >
     mWAVHeader: TMyWAVHeader;
     pWAVHeader: PMyWAVHeader;
     function WriteHeader: Boolean;
     procedure SetHeader(pData: PMyWAVHeader);
  public // Функциональность >
    property PWAV: PMyWAVHeader read pWAVHeader write SetHeader;
    function Check: Boolean; reintroduce;
    function WriteWAVData(pData: Pointer; Size: Cardinal): Boolean;
    function OpenRead(Path: String): Boolean; reintroduce;
    function OpenWrite(Path: String): Boolean; reintroduce;
    function ReadAll: Boolean; reintroduce;
  end;
    // >
  PMyULines = ^TMyULines;
  TMyULines = packed record
    m1Count: Cardinal;
    mCaption: array of PMyString;
    mSoundFile: array of PMyString;
  end;
    // >
  TMyGermanWordLine = packed record
    mGender: Byte;
    mCasus: Byte;
    mNumber: Byte;
    mLanguage: Cardinal;
    mTreeLine: TMyHDMAddress;
    mLocalLine: PMyString;
    mSynonymes: TMyULines;
    mAntonymes: TMyULines;
    mExamples: TMyULines;
    mPictures: TMyULines;

  end;
  {  // >
  TMyGermanWordList = class(TMyFileStream)
    constructor Create;
    destructor Destroy; override;
  private // "Механика" >

  public // Функциональность >

  end;
  }
    // Для строчного списка - разбор слов >
  TMyUDBTree = class;
    // Узел для чтения/записи специальных зашифрованных текстовых файлов >
  TMyStringList = class(TMyFileStream)
    constructor Create;
    destructor Destroy; override;
  private // "Механика" >
    mStrings: TMyStrings; // Массив строк произвольной ёмкости >
    mStringsCount: Cardinal; // Количество использованых строк в массиве >
    mStringsHigh: Integer; // Максимальный (высший) номер в масиве строк >
    mStringsCap: Cardinal; // Ёмкость (полная) списка строк >
    mStringsCrnt: Integer; // Текущий номер строки (той, которую спрашивали через ф-и: First,Next,This,Last) >
    mCharCodes: array [Byte] of Boolean; // Разрешённые символы >
    mDividorCodes: array [Byte] of Boolean; // Символы, которые ничего не значат >
    function SetStrCount(Value: Cardinal): Boolean;
    function GetLine(Index: Cardinal): String;
    procedure SetLine(Index: Cardinal; Value: String);
    function GetFirst: String;
    function GetNext: String;
    function GetLast: String;
    function GetThis: String;
  public // Функциональность >
    property Line[Index: Cardinal]: String read GetLine write SetLine;
    property Count: Cardinal read mStringsCount;
    property Max: Integer read mStringsHigh;
    property Capasity: Cardinal read mStringsCap;
    property First: String read GetFirst;
    property This: String read GetThis;
    property Next: String read GetNext;
    property Last: String read GetLast;
    function Add(const Value: String): Boolean; overload;
    function Add(const Value: TMyStringList): Boolean; overload;
    function Remove(Index: Cardinal): Boolean;
    function Clear: Boolean;
    function IndexOf(Value: String): Integer;
    function Exchange(Index1,Index2: Cardinal): Boolean;
    procedure Skip(Value: Cardinal = One);
    function SaveToTextFile(Path: String): Boolean;
    function LoadFromTextFile(Path: String): Boolean;
    function Scan(Caption,Path: String): Boolean;
    procedure SearchRecurse(Caption,Path: String);
    procedure ScanRecurse(Path: String);
    function Copy: TMyStringList;
    function StripStringToWords(const Value: String): Boolean;
    function StripTextFileToWords(Path: PChar): Boolean;
    function MakeCharCodes(Line: String; Value: Boolean): Boolean;
    function MakeDividorCodes(Line: String; Value: Boolean): Boolean;
    function MakeDivisionCodes(Line: String; Value: Boolean): Boolean;
  end;
    // >
  TMyApplication = class;
    // Копилка файлов >
  TMyFileTrash = class(TMyStringList)
    constructor Create(sTrashName: String; Value :TMyApplication);
    destructor Destroy; override;
  private // "Механика/начинка/устройство/вутренности" >
    mApplication: TMyApplication;
    mTrashName: String;
    mExePath: String;
    mTrashPath: String;
    procedure PathInit;
  public // Функциональность >
    property Application: TMyApplication read mApplication;
    property Path: String read mTrashPath;
    function FileExisto(sName: String): Boolean; // Существует такой файл в "копилке"? >
    function FilePath(sName: String): String;
    function FilePPath(sName: String): PChar;
    function FileCopyIn(const Path: String; ReMoveEx: Boolean = false; OverWrite: Boolean = false): Boolean; // Просто скопировать >
    function FileMoveIn(const Path: String): Boolean; // Скопировать, так, чтобы "одинаковость имени" не помешала добавить в копилку новый (с проверкой) файл >
    function AddExtension(const Value: String): Boolean;
    procedure FilesCopyIn(const Path: String); // Скопировать внутрь всё из указанной папки - для массового перемещения файлов >
    procedure FilesMoveIn(const Path: String); // Переместить внутрь всё из указанной папки - для массового перемещения файлов >
    function RecurseCopyScan(bDelete: Boolean): Cardinal;
    procedure ScanRecurse; overload;
  end;
    // Лог - заодно переводчик и писатель 8) >
  TMyLog = class(TMyStringList)
    constructor Create(Value: TMyFileTrash; cName: String);
    destructor Destroy; override;
  private // "Механика" >
    mFileName: String;
  public // Функциональность >
    procedure WriteLog; overload;
    procedure WriteLog(Value: String); overload;
    procedure WriteLog(Index: Cardinal); overload;
    procedure WriteLog(Index,Value: Cardinal); overload;
    procedure WriteLog(Index1, Index2: Cardinal; AdditionalValue: String); overload;
    procedure WriteLog(Index: Cardinal; AdditionalValue: String); overload;
    procedure WriteLog(Index: Cardinal; AdditionalValue: String; Result: Boolean); overload;
    procedure WriteLog(Index: Cardinal; Result: Boolean); overload;
    procedure WriteLog(Coment: String; Value: Integer); overload;
    procedure ClearLog;
  end;
    // Загрузчик библиотек 8) >
  TMyLibModule = class(TMyStringList)
    constructor Create(Path: String; Value: TMyApplication = nil); overload;
    constructor Create(Path,Replacer: String; Value: TMyApplication = nil); overload;
    destructor Destroy; override;
  private // "Механика" >
    mModuleHandle: Cardinal;
    mApplication: TMyApplication;
  public // Функциональность >
    property Handle: Cardinal read mModuleHandle;
    property Application: TMyApplication read mApplication;
    function Check: Boolean; reintroduce;
    procedure SetEP(var pData: Pointer);
  end;
    // Структура описывающая переменные в структуре "универсального" "типа" >
  PMyVariableType = ^TMyVariableType; // Указатель >
  TMyVariableType = packed record // "Экономия места" >
    mName: TMyHDMAddress; // Имя переменной >
    mType: TMyHDMAddress; // Тип переменной (указатель на то, что описано чуть ниже ) >
    mValues: TMyHDMAddress; // Массив (сколько такого типа и под таким же именем будет) "переменных" >
    mParentVariable: TMyHDMAddress; // Предыдущее "поле" (верхнее/родительское) >
    mChildVariable: TMyHDMAddress; // Следующее "поле" (нижнее/дочернее) >
  end;
    // Структура универсального описания типов для БД >
  PMyType = ^TMyType; // Указатель >
  TMyType = packed record // "Экономия места" >
    mName: TMyHDMAddress; // *Указатель* (в дереве на слово - название типа, как в "Дэлфи") >
    mInherited: TMyHDMAddress; // *Указатель* (в списке типов) на тип, от которого происходит наследование (может быть пустым) >
    mObjects: TMyHDMAddress; // *Список* всех переменных (существующих "значений/полей/и т.д.") данного типа >
    mVariables: TMyHDMAddress; // *Список* типов (описание), из которых состоит данный *тип*, его поля, методы, свойства, связи и прочее >
  end;
    // Структура узла в дереве - накопителей >
  PMyHDMTreeNode = ^TMyHDMTreeNode;
  TMyHDMTreeNode = packed record
    mChildNodes: array [Byte] of TMyHDMAddress; // Массив дочерних узлов >
    mParentNode: TMyHDMAddress; // Адрес родительского узла >
    mParentIndex: SmallInt; // Номер в родительском списке >
    mHeight: Cardinal; // Расстояние до первого узла - первый узел имеет единичную высоту >
    mLink: TMyHDMAddress; // Адрес ссылки на параметры узла - сигнализирует о значимости данного узла >
  end;
    // Структура, описывающая связь с деревом узлов отдельных параметров >
  PMyHDMTreeLink = ^TMyHDMTreeLink;
  TMyHDMTreeLink = packed record
    mParentNode: TMyHDMAddress; // Указывает на узел-хозяин >
    mParams: TMyHDMAddress; // Указывает на параметры узла - может отсутствовать, если узел не имеет никакой значимости, кроме набора абстрактных данных >
    mUsedTimes: TMyHDMAddress; // Количество проходов\использований данной ССЫЛКИ >
  end;
    // Структура описывающая связь узлов в дереве между собой: тип\характер связи + указатель, может исползоваться, как длиннючий массив связей >
  PMyHDMAssosiation = ^TMyHDMAssosiation;
  TMyHDMAssosiation = packed record
    mParentBind: TMyHDMAddress; // Верхняя связь в списке >
    mChildBind: TMyHDMAddress; // Нижняя связь в списке >
    mHostNode: TMyHDMAddress; // Родительский узел >
    mTargetNode: TMyHDMAddress; // Целевой узел >
    mCoeffitient: Single; // Коэфициент\калибровка точности >
  end;
    // Параметры узла - его функциональнсти, указатели на непосредственные данные >
  PMyHDMNodeParams = ^TMyHDMNodeParams;
  TMyHDMNodeParams = packed record
    mParentNode: TMyHDMAddress; // Указатель на узел-хазяин >
    mParentLink: TMyHDMAddress; // Указатель на ссылку, указывающую на эту конструкцию >
    mFirstBind: TMyHDMAddress;
    mBindsCount: TMyHDMAddress;
    mDescription: TMyHDMAddress; // Описание-указатель >
    mCreate: TMyTime; // Время создания >
    mEdit: TMyTime; // Время последнего изменения >
    mView: TMyTime; // Время последнего обращения\чтения >
    mExtra: TMyHDMAddress; // Указатель на дополнительные данные - обычно пустой >
    mReserved: TMyHDMAddress; // Зарезервированный указатель - предполагается, что он будет всегда пустым - на крайний непредвиденный случай >
  end;
    // Заголовок для данной БД (дерева и остальных файлов) >
  PMyHDMHeader = ^TMyHDMHeader;
  TMyHDMHeader = packed record
    mShift: Byte; // Сдвиг >
    mLogin: array [Byte] of Byte; // Логин (имя пользователя) >
    mPassword: array [Byte] of Byte; // Пароль >
  end;
    // Опережающее описание, пока даже не известн для чего >
  TMyUDB = class;
    // Специальная модификация текстового списка (расширеная и специализированная) >
  TMyTextAnalyser = class(TMyStringList)
    constructor Create(Value: TMyUDB); // Консруктор >
    destructor Destroy; override; // Деструктор >
  private // Внутренняя часть >
    mUDB: TMyUDB; // Ссылка на "БД-хозяина" >
  public // Функционал >
    property UDB: TMyUDB read mUDB;
    function ReadAndRememderWords(Path: PChar): Boolean;
    function ExtractNodesWithParams: Boolean;
  end;
    // Класс-контроллер для навигации\записи\чтения и древовидной памяти >
  TMyUDBTree = class(TMyFileStream)
    constructor Create; // Консруктор >
    destructor Destroy; override; // Деструктор >
  private // Вспомогательная часть >
    mUDBParent: TMyUDB;
    mNodeBuff: array of PMyHDMTreeNode;
    mNodeBuffHigh: Integer;
    mNodeBuffCount: Cardinal;
    mNodeBuffCapasity: Cardinal;
    mNodeBuffCapasityInc: Cardinal;
    function BuffSetCount(Value: Cardinal): Boolean;
    function BuffSetLength(Value: Cardinal): Boolean;
    function BuffClear: Boolean;
    function BuffDestroy: Boolean;
    function MakeFirstNode: Boolean;
  public // Функциональность >
    property UDB: TMyUDB read mUDBParent;
    function Count: TMyHDMAddress; // Количество узлов в дереве >
    function Address(const Value: String): TMyHDMAddress;
    function Link(const Value: String): TMyHDMAddress;
    function Info(const Value: String): String;
    function Add(const Value: String; cType: Cardinal = Zero): TMyHDMAddress; overload; // Написать "в дерево", возвращает адрес узла, на котором остановилась запись >
    function Add(const pData: PChar; cType: Cardinal = Zero): TMyHDMAddress; overload; // Записать в дерево строку "PChar" >
    function Add(pData: Pointer; cSize: TMyHDMAddress; cType: Cardinal = Zero): TMyHDMAddress; overload; // Записать в дерево набор абстрактных данных >
    function Add(pData: PMyString; cType: Cardinal = One): TMyHDMAddress; overload;
    function Get(Address: TMyHDMAddress; out Value: String): Boolean; overload;
    function Get(Address: TMyHDMAddress; out pData: PChar): Boolean; overload;
    function Get(Address: TMyHDMAddress; out pData: Pointer; var cSize: Cardinal): Boolean; overload;
    function Get(Address: TMyHDMAddress; pData: PMyString): Boolean; overload;
  end;
    // Класс-контроллер для навигации\использования первичных ссылок >
  TMyUDBLink = class(TMyFileStream)
    constructor Create; // Консруктор >
    destructor Destroy; override; // Деструктор >
  private // Вспомогательная часть >
    mUDBParent: TMyUDB;
  public // Функциональность >
    property UDB: TMyUDB read mUDBParent;
    function Count: TMyHDMAddress; // Количество ссылок в списке >
    function MakeLink(const cNode: TMyHDMAddress): TMyHDMAddress;
    function MakeLinkAndParams(const cNode: TMyHDMAddress): TMyHDMAddress;
    procedure UpDateLink(const cLink: TMyHDMAddress);
    procedure UpDateLinkAndParams(const cLink: TMyHDMAddress);
    function LinkedNode(cNumber: Cardinal): TMyHDMAddress; overload;
    function LinkedNode(const cLink: TMyHDMAddress): TMyHDMAddress; overload;
    function LinkedParams(cNumber: Cardinal): TMyHDMAddress; overload;
    function LinkedParams(const cLink: TMyHDMAddress): TMyHDMAddress; overload;
  end;
    // Класс-контроллер для навигации\редактирования параметров узлов дерева >
  TMyUDBNodeParams = class(TMyFileStream)
    constructor Create; // Консруктор >
    destructor Destroy; override; // Деструктор >
  private // Вспомогательная часть >
    mUDBParent: TMyUDB;
  public // Функциональность >
    property UDB: TMyUDB read mUDBParent;
    function Count: TMyHDMAddress; // Количество "параметров" в списке >
    function MakeParams(const cNode,cLink: TMyHDMAddress): TMyHDMAddress;
    procedure UpDateParams(const cParams: TMyHDMAddress);
    function ParamsNode(cNumber: Cardinal): TMyHDMAddress; overload;
    function ParamsNode(const cParams: TMyHDMAddress): TMyHDMAddress; overload;
    function ParamsLink(cNumber: Cardinal): TMyHDMAddress; overload;
    function ParamsLink(const cParams: TMyHDMAddress): TMyHDMAddress; overload;
  end;
    // Класс-контролер для навигации редактирования связей между узлами дерева >
  TMyUDBAssosiations = class(TMyFileStream)
    constructor Create; // Консруктор >
    destructor Destroy; override; // Деструктор >
  private // Вспомогательная часть >
    mUDBParent: TMyUDB;
  public // Функциональность >
    property UDB: TMyUDB read mUDBParent;
    function Bind(cNode1,cNode2: TMyHDMAddress): TMyHDMAddress;
    function UnBind(cNode1,cNode2: TMyHDMAddress): TMyHDMAddress;
    function Binded(cNode1,cNode2: TMyHDMAddress): TMyHDMAddress;
  end;
    // Класс-контролер для навигации и редактирования эмоциональных параметров >
  TMyUDBSenses = class(TMyFileStream)
    constructor Create; // Консруктор >
    destructor Destroy; override; // Деструктор >
  private // Вспомогательная часть >
    mUDBParent: TMyUDB;
  public // Функциональность >
    property UDB: TMyUDB read mUDBParent;
  end;
    // Класс обеспечивающий всю функциональность UBD-системмы >
  TMyUDB = class(TMyParent)
    constructor Create(Value: TMyApplication); // Консруктор >
    destructor Destroy; override; // Деструктор >
  private // Вспомогательная часть >
    mDataTree: TMyUDBTree;
    mDataTreeLinks: TMyUDBLink;
    mDataTreeAssosiations: TMyUDBAssosiations;
    mDataTreeParams: TMyUDBNodeParams;
    mTextAnalyser: TMyTextAnalyser;
    mSenses: TMyUDBSenses;
    mDBFileName: String;
    mApplication: TMyApplication;
  public // Функциональность >
    property DataBaseFileName: String read mDBFileName; // Имя БД (путь к каталогу на диске) >
    property Tree: TMyUDBTree read mDataTree; // Прямой доступ к дереву >
    property Links: TMyUDBLink read mDataTreeLinks; // Прямой доступ к ссылкам >
    property Params: TMyUDBNodeParams read mDataTreeParams; // Прямой доступ к "параметрам узлов" >
    property Binds: TMyUDBAssosiations read mDataTreeAssosiations; // Прямой доступ к связям >
    property TextAnalyser: TMyTextAnalyser read mTextAnalyser; // Часть адаптированная для текстового взаимодействия >
    property Senses: TMyUDBSenses read mSenses;
    property FileTrash: TMyApplication read mApplication;
    function Opened: Boolean; // Открыта-ли БД >
    function Build(Value: String): Boolean; // Создать >
    function Open(Value: String): Boolean; // Открыть\загрузить >
    function Copy(Value: String; OverWrite: Boolean = true): Boolean; // Копировать >
    function Erase: Boolean; // Открыть\загрузить >
    function Close: Boolean; // Закрыть >
  end;
    // Обозреватель, который может только видеть место, в котором находится ;) >
  TMyNodeExplorer = class(TMyParent)
    constructor Create(Value: TMyNode); // Конструктр >
    destructor Destroy; override; // Деструктор >
  private // "Скрытая" часть >
    mPosition: TMyNode;
    procedure SetPosition(Value: TMyNode);
  public
    property Position: TMyNode read mPosition write SetPosition;
  end;
    // Процессор >
  TMyCPU = class(TMyNode)
    constructor Create; // Конструктр >
    destructor Destroy; override; // Деструктор >
  private // "Скрытая" часть >
    mCPUSpeed: Single;
  public
    property CPUSpeed: Single read mCPUSpeed;
  end;
    // Свойства ОС Windows >
  TMyWindows = class(TMyNode)
    constructor Create; // Конструктр >
    destructor Destroy; override; // Деструктор >
  private // Внутренняя механика класса >
    mCSDVersion: String;
    mNucleusName: String;
    mNucleusPath: String;
    mBuild: Cardinal;
    mMajorVersion: Cardinal;
    mMinorVersion: Cardinal;
    mPlatformId: Cardinal;
    mWindows: array of String;
    mWindowsCount: Cardinal;
    mWindowsHigh: Integer;
    procedure GetWindowsList;
  public // Функционал класса >
    property CSDVersion: String read mCSDVersion;
    property NucleusName: String read mNucleusName;
    property NucleusPath: String read mNucleusPath;
    property Build: Cardinal read mBuild;
    property MajorVersion: Cardinal read mMajorVersion;
    property MinorVersion: Cardinal read mMinorVersion;
    property PlatformId: Cardinal read mPlatformId;
    function ExitSession(cType: Cardinal; cPrivilege: Boolean = false): Boolean;
  end;
    // Оперативная память >
  TMyRAM = class(TMyNode)
    constructor Create; // Конструктр >
    destructor Destroy; override; // Деструктор >
  private // Внутренняя механика класса >
    mMemoryLoad: Cardinal;
    mTotalPhysical: Cardinal;
    mAvailPhysical: Cardinal;
    mUsedPhysical: Cardinal;
    mTotalPageFile: Cardinal;
    mAvailPageFile: Cardinal;
    mUsedPageFile: Cardinal;
    mTotalVirtual: Cardinal;
    mAvailVirtual: Cardinal;
    mUsedVirtual: Cardinal;
  public // Функционал класса >
    property MemoryLoad: Cardinal read mMemoryLoad;
    property TotalPhysical: Cardinal read mTotalPhysical;
    property FreePhysical: Cardinal read mAvailPhysical;
    property UsedPhysical: Cardinal read mUsedPhysical;
    property TotalPageFile: Cardinal read mTotalPageFile;
    property FreePageFile: Cardinal read mAvailPageFile;
    property UsedPageFile: Cardinal read mUsedPageFile;
    property TotalVirtual: Cardinal read mTotalVirtual;
    property FreeVirtual: Cardinal read mAvailVirtual;
    property UsedVirtual: Cardinal read mUsedVirtual;
    function UpDate: Boolean;
  end;
    // Тут будут храниться параметры процесса >
  PMyProcParams = ^TMyProcParams;
  TMyProcParams = packed record
    Name: String;
    mPID: Cardinal;
  end;
    // Список процессов >
  TMyProcessList = class(TMyNode)
    constructor Create(Value: TMyApplication = nil); // Конструктр >
    destructor Destroy; override; // Деструктор >
  private // "Скрытая" часть >
    mApplication: TMyApplication;
    mProc: array of TMyProcParams;
    mProcCount: Cardinal;
    mProcHigh: Integer;
    mAllKnownList: TMyStringList;
    mSystemList: TMyStringList;
    mBad: TMyStringList;
    function GetProcess(Index: Cardinal): PMyProcParams;
  public // Функционал класса >
    property Application: TMyApplication read mApplication;
    property Count: Cardinal read mProcCount;
    property Max: Integer read mProcHigh;
    property Item[Index: Cardinal]: PMyProcParams read GetProcess;
    property Known: TMyStringList read mAllKnownList;
    property System: TMyStringList read mSystemList;
    property Bad: TMyStringList read mBad;
    function UpDate: Boolean;
    function Refresh: Boolean;
    function IndexOf(Value: String): Integer;
    function Terminate(Index: Cardinal): Boolean;
    function TerminateDebug(Index: Cardinal): Boolean;
    function TerminateSelf: Boolean;
  end;
    // Дополнительная информация по приводу\устройству\диску >
  PMyAdditionalDriveInfo = ^TMyAdditionalDriveInfo;
  TMyAdditionalDriveInfo = packed record
    FileSystemFlags: Cardinal; // Флаги файловой системмы >
    SerialNumber: Cardinal; // Серийный номер >
    FileSystem: String; // Название файловой системмы >
    BytesPerSector: Cardinal; // Байт в секторе >
    SectorsPerCluster: Cardinal; // Секторов в кластере >
    NumberOfFreeClusters: Cardinal; // Свободных кластеров >
    TotalNumberOfClusters: Cardinal; // Всего кластеров >
    DriveType: Cardinal; // Тип устройства носителя данного раздела\диска и т.д. >
  end;
    // Обычные свойства "диска" >
  PMyDriveParams = ^TMyDriveParams;
  TMyDriveParams = packed record
    FullSize: Int64; // Размер >
    FreeSize: Int64; // Свободно >
    UsedSize: Int64; // Занято >
    VolumeLabel: String; // Метка тома >
    Additional: TMyAdditionalDriveInfo; // Дополнительно >
  end;
    // Диск/привод/образ/устройство >
  TMyDrive = class(TMyNode)
    constructor Create(Value: Char); // Конструктр >
    destructor Destroy; override; // Деструктор >
  private // "Скрытая" часть >
    mParams: TMyDriveParams;
    pParams: PMyDriveParams;
  public // Функционал класса >
    property FullSize: Int64 read mParams.FullSize; // Размер >
    property FreeSize: Int64 read mParams.FreeSize; // Свободно >
    property UsedSize: Int64 read mParams.UsedSize; // Занято >
    property VolumeLabel: String read mParams.VolumeLabel; // Метка тома >
    property Params: PMyDriveParams read pParams; // Указатель на хранилище всех известных данных >
    function UpDate: Boolean;
  end;
    // Битовое полe, как 32 флага, короче 4 байта >
  TMyDrivesSet = set of Zero..mnMaxDrive;
    // Диски/приводы/образы/устройства хранения данных/накопители/съёмные носители >
  TMyDrives = class(TMyNode)
    constructor Create; // Конструктр >
    destructor Destroy; override; // Деструктор >
  public // Функционал класса >
    function UpDate: Boolean;
  end;
    // Класс специального узла "Мой компьютер", по аналогии с виндовской структорой >
  TMyApplication = class(TMyNode)
    constructor Create(Protection: Boolean); // Конструктр >
    destructor Destroy; override; // Деструктор >
  private // "Скрытая" часть >
    mExeName: String;
    mComputerName: String;
    mStringList: TMyStringList;
    mFileTrash: TMyFileTrash;
    mLog: TMyLog;
    mUDB: TMyUDB;
    mNodeExplorer: TMyNodeExplorer;
    mCPU: TMyCPU;
    mRAM: TMyRam;
    mWindows: TMyWindows;
    mDrives: TMyDrives;
    mProcList: TMyProcessList;
  public // Функционал класса >
    property ExeName: String read mExeName;
    property ComputerName: String read mComputerName;
    property FileTrash: TMyFileTrash read mFileTrash; // Файловая мусорка "по умолчанию" >
    property Log: TMyLog read mLog; // Лог и тексты, строчки >
    property UDB: TMyUDB read mUDB; // Гиперпамять >
    property NodeExplorer: TMyNodeExplorer read mNodeExplorer; // *Обозреватель* "по умолчанию" >
    property CPU: TMyCPU read mCPU; // Процессор >
    property RAM: TMyRam read mRAM; // Оперативная память >
    property Windows: TMyWindows read mWindows; // ОС уиндоусъ >
    property Drives: TMyDrives read mDrives; // Носители данных >
    property ProcList: TMyProcessList read mProcList; // Список процессов >
    property StringList: TMyStringList read mStringList; // Просто строчны лист типа String >
    function UpDate: Boolean;
    procedure HaltM;
  end;
//=============================================================================>
//================================= Константы =================================>
//=============================================================================>
const // Типы дисков >
  wdt_Unknown = Zero; // Неизвестен >
  wdt_dtNoDrive = One; // Отсутствует >
  wdt_dtFloppy = Two; // Флоппи >
  wdt_dtFixed = Three; // Жёсткий диск >
  wdt_dtNetwork = Four; // Сетевой\подключённый диск >
  wdt_dtCDROM = Five; // CD\DVD-ROM >
  wdt_dtRAM = Six; // Флешка и прочие сёмные носители >
    // Файловые флаги (SysUtils) >
  faHidden = $00000002; // Скрытый (platform) >
  faSysFile = $00000004; // Системный (platform) >
  faVolumeID = $00000008; // Метка тома (раздел/диск) (platform) >
  faDirectory = $00000010; // Дирректория (папка/каталог) >
  faAnyFile = $0000003F; // Любой файл >
  faSpecial = faHidden or faSysFile or faVolumeID or faDirectory;
  faUsual = not faAnyFile and faSpecial;
    // Номера встроенных строк из лога >
  mnl_Start = _0; // Запуск программы >
  mnl_End = _1; // Остановка программы >
  mnl_Error = _2; // Ошибка >
  mnl_Message = _3; // Сообщение >
  mnl_STACK_UNDERFLOW = _4; // Потеря значимости стека (опустошение) >
  mnl_INVALID_ENUM = _5; // Не правильный тип аргумента >
  mnl_INVALID_VALUE = _6; // Не правильное значение аргумента >
  mnl_INVALID_OPERATION = _7; // Не правильная операция >
  mnl_STACK_OVERFLOW = _8; // Переполнение стека >
  mnl_OUT_OF_MEMORY = _9; // Не хватает памяти >
  mnl_NO_ERROR = _10; // Нет ошибок >
  mnl_GL_VENDOR = _11; // производитель >
  mnl_GL_RENDERER = _12; // Видеокарта >
  mnl_GL_VERSION = _13; // Версия OpenGL >
  mnl_GL_EXTENSIONS = _14; // Список расширений OpenGL >
  mnl_AL_VENDOR = _15; // Изготовитель >
  mnl_AL_VERSION = _16; // Версия OpenGL >
  mnl_AL_RENDERER = _17; // Аудиоустройство >
  mnl_AL_EXTENSIONS = _18; // Список расширений OpenAL >
  mnl_GL_INITIALIZATION = _19; // Инициализация OpenGL >
  mnl_AL_INITIALIZATION = _20; // Инициализация OpenAL >
  mnl_GL_INITIALIZATION_OK = _21; // Видеоконвеер активирован >
  mnl_AL_INITIALIZATION_OK = _22; // Аудиоконвеер активирован >
  mnl_WINDOW_CREATED = _23; // Окно создано >
  mnl_INPUT_INIT = _24; // Активация ввода >
  mnl_DRAW_LINE_INIT_START = _25; // Создание конвеера воспроизведения >
  mnl_DRAW_LINE_INIT_COMPLETE = 26; // Конвеер воспроизведения создан >
  mnl_TEXTURE_INIT_COMPLETE = 27; // Текстуры инициализированы >
  mnl_GLSL_INIT_COMPLETE = _28; // Шейдеры инициализированы >
  mnl_LIGHT_INIT_COMPLETE = _29; // Освещение инициализировано >
  mnl_FOG_INIT_COMPLETE = _30; // Туман инициализирован >
  mnl_CAMERA_INIT_COMPLETE = _31; // Камера инициализирована >
  mnl_PATCH_INIT_COMPLETE = _32; // Загружен патч >
  mnl_SOUND_LINE_INIT_START = 33; // Создание аудиоконвеера >
  mnl_SOUND_LINE_INIT_COMPLETE = 34; // Аудиоконвеер создан >
  mnl_EXPLORER_INIT_COMPLETE = 35; // Древо-путеводитель по компу >
  mnl_Extension_check = 36; // Проверка доступности расширения >
  mnl_YES = 37; // Да >
  mnl_NO = 38; // Нет >
  mnl_FreeImage_Loaded = 39; // Загрузчик картинок (FreeImage.dll) готов; версия и копирайт = >
  mnl_BASS_Loaded = 40; // Bass.dll загружена >
  mnl_ZLib_Loaded = 41; // ZLib1.dll готова к дефляции, версия = >
  mnl_PATCH_FIN_COMPLETE = 42; // Выгружен патч >
  mnl_PATCH_INTERNET_DOWNLOAD = 43; // Из интернета загружен >
  mnl_INTERNET_DOWNLOADED = 44; // Загружено из интернэта >
  mnl_INPUT_FINALIZE = 45; // Финализация ввода >
  mnl_DRAW_FINALIZE = 46; // Финализация видео конвеера >
  mnl_OPENGL_FINALIZE = 47; // Финализация OpenGL >
  mnl_CAMERA_FINALIZE = 48; // Финализация камер >
  mnl_OPENAL_FINALIZE = 49; // Финализация OpenAL >
  mnl_SOUND_FINALIZE = 50; // Финализация звука >
  mnl_NODE_FINALIZATION = 51; // Уничтожение узлов >
  mnl_AVICAP_INITIALIZE = 52; // Загрузка AVICAP32.DLL >
  mnl_SKIP_3 = 53; //   -=> >
  mnl_SKIP_5 = 54; //     -=> >
  mnl_WebInit = 55; // Инициализация "интернета" (wininet.dll) >
  mnl_NetWorkInit = 56; // Инициализация "сети" ("Сокеты" WS2_32.DLL) >
  mnl_ShellInit = 57; // Инициализация Shell (Shell32.dll) >
  mnl_MPG123Init = 58; // Инициализация mp3 codec'a (mpg123.dll) >
  mnl_OggInit = 59; // Инициализация Ogg codec'a >
  mnl_OLEInit = _60; // Инициализация OLE (ole32.dll) >
  mnl_AVIFILE_INITIALIZE = _61; // Загрузка AVIFIL32.DLL >
  mnl_VFW_INITIALIZE = _62; // Загрузка MSVFW32.DLL >
  mnl_NEWTON_INITIALIZE = _63; // Инициализация физики, на основе NewtonGameDynamics (Newton.dll) >
  mnl_SESSION_GUID = _64; // Глобально уникальный идентификатор сеанса >
  mnl_UDB_OPEN = _65; // Инициализация гиперпамяти (подключение) >
  mnl_UDB_CREATE = _66; // Инициализация гиперпамяти (создание) >
  mnl_UDB_TREE_COUNT = 67; // Количество "узлов" в дереве "гиперпамяти" >
  mnl_UDB_TREE_SIZE = 68; // Размер файла "гиперпамяти" >
  mnl_UDB_LINKS_COUNT = 69; // Количесство "ссылок" >
  mnl_UDB_LINKS_SIZE = 70; // Размер файла "ссылок" >
  mnl_UDB_PARAMS_COUNT = 71; // Количество записей "параметров" >
  mnl_UDB_PARAMS_SIZE = 72; // Размер файла записей "параметров" >
  mnl_WINDOWS_NAME = 73; // Название ОС >
  mnl_RAM_TOTAL = 74; // Всего физической памяти >
  mnl_RAM_USED = 75; // Оперативной памяти использовано >
  mnl_RAM_FREE = 76; // Оперативной памяти свободно >
  mnl_CPU_SPEED = 77; // Скорость процессора >
  mnl_WINDOWS_DIRECTORY = 78; // Каталог с виндой >
  mnl_PLATFORM_ID = 79; // Идентификатор платформы >
  mnl_COMPUTER_WINDOWS_NAME = 80; // Название компа в виндовсе >
  mnl_USERER_WINDOWS_NAME = 81; // Имя пользователя винды, запустившего эту программу >
  mnl_APPLICATION_NAME = 82; // Имя (без пути и расширения) запущенного экзэшника, в котором это "приложение" находится (работает?) >
  mnl_PROCESS_STOPED = 83; // Процесс остановлен >
  mnl_EXE_FILE_CORUPTED = 84; // Пусковой файл изменён >
  mnl_EXE_MOVED_TO_VIRE = 85; // Пусково файл отправлен в карантин >
  mnl_BAT_SELF_ERASE = 86; // Создание процесса, который должен экзэшник данной программы уничтожить >
  mnl_SELF_PROCESS_DESTRUCTION = 87; // Попытка остановить свой процесс >
  mnl_SELF_BUC_CREATION = 88; // Создание собственной запасной копии >
  mnl_LUNCHING_REPAIR_PROGRAM = 89; // Запуск программы-перезапускателя >
    // Размеры/ёмкости разных типов данных и т.д. и т.п. м.б. >
  cBitmapInfoSize = SizeOf(TBitMapInfo);
  cBitmapInfoHeaderSize = SizeOf(TBitmapInfoHeader);
  cUsualAudioBufferSize = _8192*Five; // Стандартный размер для аудиобуффера >
  cWAVHeaderSize: Cardinal = SizeOf(TMyWAVHeader); // Размер заголовка *.WAV файла >
  cTMyNodePackSize: Cardinal = SizeOf(TMyNodePack); // Размер упаковки записей узла >
  cTMyHDMAddress = SizeOf(TMyHDMAddress);
  cTMyHDMTreeNode = SizeOf(TMyHDMTreeNode);
  cTMyHDMTreeLink = SizeOf(TMyHDMTreeLink);
  cTMyHDMNodeParams = SizeOf(TMyHDMNodeParams);
  cTMyHDMAssosiation = SizeOf(TMyHDMAssosiation);
  cTMyHDMHeader = SizeOf(TMyHDMHeader);
    // Привелегии >
  mnDebug = 'SeDebugPrivilege';
  mnShutdown = 'SeShutdownPrivilege';
  mniDebug = One;
  mniShutdown = Two;
    // Смешанные %) >
  INVALID_HANDLE = INVALID_HANDLE_VALUE; // Неправильный результат >
  INVALID_HV = Zero; // Неправильный результат (хреновый дескриптор) >
  mnBMP = $4D42; // Нормальный BitMap >
  mCPUDT = _100; // время измерения в миллисекундах, за которое мы будем считать такты >
  mRIFF: TMy4Char = 'RIFF'; // Зарезервированное начало заголовка >
  mR_WAV: TMy4Char = 'WAVE'; // Тип для несжатого звука >
  mR_DATA: TMy4Char = 'data'; // Это означает начала куска с данными >
  mR_SC1ID: TMy4Char = 'fmt'#$20; // Формат >
  mnCharTablePath: String = 'Chars.txt'; // Таблица\список кодов символов, которые являются буквенными, то есть кодируют буквы >
  mnLabelUnit: String = 'unit'; // Метка\зарезервированное слово, означающее начало модуля\куска программы описанного ввыделяющих метках\тэгах\зарезервированных словах >
  mnLabelUnitEnd: String = 'end.'; // Конец раздела реализации и всего модуля\кода\текста >
  mnLabelInterface: String = 'Interface'; // Начало раздела описаний >
  mnLabelImplementation: String = 'Implementation'; // Конец раздела описаний, начало раздела реализации >
  mnLabelUses: String = 'Uses'; // Использованые\мые модули >
  mnLabelConst: String = 'Const'; // Список констант >
  mnLabelType: String = 'Type'; // типов: новых структур, массивов, псевдонимов, классов, интерфейсов и т.д. и т.п. >
  mnLabelVar: String = 'Var'; // переменные >
  mnTrashDir: String = 'Data'; // Название хранилища файлов >
  mnLogPath: String = 'Log.txt'; // Адрес журнала >
  mnLogLines: String = 'Lines.txt'; // Локализация >
  mnBadProcList: String = 'BadProcList.txt'; // Плохие процессы = нужно постараться закрыть >
  mnAllProcList: String = 'AllProcList.txt'; // Все известные(обнаруженные когда-либо) процессы >
  mnSystemProcList: String = 'SystemProcList.txt'; // Системные процессы >
  mnHyperMem: String = 'TAI1'; // Название гипрпамяти, открываемой по умолчанию >
  mnTransVocabularyDataBase: String = 'TrVoDaBa'; // Связная БД для заметок и формулировок, переводов и примеров с аналогиями >
  cTMyDBName: String = '.UDBT'; // Само "дерево" >
  cTMyLBName: String = '.UDBL'; // "Ссылки" >
  cTMyBBName: String = '.UDBB'; // "Связи" >
  cTMyPBName: String = '.UDBP'; // "Дополнительные параметры" >
  cTMySBName: String = '.UDBS'; // Массив ощущуений >
//=============================================================================>
//=========================== Функциональность модуля =========================>
//=============================================================================>
  procedure ShowMessage(const Value: String); overload;
  procedure ShowMessage(Value: Integer); overload;
  procedure ShowMessage(pData: PMyString); overload;
  procedure DeleteByBat(Adress: String);
  procedure UpDatePMyTime(var pData: PMyTime);
  function GetMyTime: TMyTime;
  function GetDiskFreeSpaceEx(Directory: PChar; var FreeAvailable,TotalSpace: TLargeInteger; TotalFree: PLargeInteger): Bool stdcall; external kernel32 name 'GetDiskFreeSpaceExA';
  function SaveToMappedFile(pPath: PChar; pData: Pointer; Size: Cardinal): Boolean;
  function LoadFromMappedFile(pPath: PChar; var pData: Pointer; var Size: Cardinal): Boolean;
  function FileSize(pPath: PChar): Int64; overload;
  function FileSize(const Path: String): Cardinal; overload;
  function FileExists(const Path: String): Boolean; overload;
  function FileExists(pPath: PChar): Boolean; overload;
  function FindMatchingFile(pData: PSearchRec): Cardinal;
  function AskQuestionYesNo(const sHeader,sValue: String): Boolean;
  function SetMonitorState(State: Boolean): Boolean;
  function RunThreadedFunction(pData: PMyTHreadedFunction): Boolean;
  function GetStartButtonHandle: Cardinal;
  function ChangeScreenSet(Width,Height,ColorDepth,Frequency: Cardinal): Boolean;
  function ChangeScreenSetBack: Boolean;
  function GetWindowsUserName: String;
  function GetWindowsComputerName: String;
  function ActivateMyPrivilege(PrivilegeIndex: Cardinal; State: Boolean): boolean;
  function MyWindowsExit(uFlags: Cardinal): Boolean;
  function GetWindowsError: String;
  function SetPriority(Value: Cardinal): Boolean;
  function MyLoadLibrary(pPath: Pchar; var libHandle: Cardinal): Boolean;
  function MyGetProcAddress(var libHandle: Cardinal; var pProcPointer: Pointer; pProcName: PChar): Boolean;
  function LunchProgram(CommandLine: String; WaitTermination: Boolean = false): Boolean;
  function DeleteDirectory(const Path: String): Boolean;
//=============================================================================>
//============================= Глобальные переменные =========================>
//=============================================================================>
var
  mIntegerSize: Integer = cIntegerSize;
//=============================================================================>
//============================= Раздел реализации =============================>
//=============================================================================>
implementation
  // Удалить рекурсивным обходом дирректоррриииюю >
function DeleteDirectory(const Path: String): Boolean;
var a1:Cardinal; v3:TWin32FindData;
begin
a1:=FindFirstFile(PChar(SlashSep(Path,mnSearchMask)),v3);
if a1 = INVALID_HANDLE_VALUE then
Result:=true else begin
if String(v3.cFileName) = mnDirIn then
Result:=true else
if String(v3.cFileName) <> mnDirNameUp then
Result:=true else
if (v3.dwFileAttributes and FILE_ATTRIBUTE_DIRECTORY) > Zero then
Result:=DeleteDirectory(SlashSep(Path,v3.cFileName)) else
Result:=DeleteFile(PChar(SlashSep(Path,v3.cFileName)));;
if Result then
while FindNextFile(a1,v3) do
if String(v3.cFileName) <> mnDirIn then
if String(v3.cFileName) <> mnDirNameUp then begin
if (v3.dwFileAttributes and FILE_ATTRIBUTE_DIRECTORY) > Zero then
Result:=DeleteDirectory(SlashSep(Path,v3.cFileName)) else
Result:=DeleteFile(PChar(SlashSep(Path,v3.cFileName)));
if not Result then
Break; end;
FindClose(a1); end;
if Result then
Result:=RemoveDirectory(PChar(Path));
end;
  // Загрузка библиотеки с проверкой >
function MyLoadLibrary(pPath: Pchar; var libHandle: Cardinal): Boolean;
begin
if Assigned(pPath) then
if FileExists(pPath) then
libHandle:=LoadLibrary(pPath) else
libHandle:=INVALID_HV else
libHandle:=INVALID_HV;
Result:=libHandle <> INVALID_HV;
end;
  // Загрузка точки входа в функцию из библиотеки >
function MyGetProcAddress(var libHandle: Cardinal; var pProcPointer: Pointer; pProcName: PChar): Boolean;
begin
if libHandle = INVALID_HV then
pProcPointer:=nil else
pProcPointer:=GetProcAddress(libHandle,pProcName);
Result:=Assigned(pProcPointer);
end;
  // Запустить программу ... >
function LunchProgram(CommandLine: String; WaitTermination: Boolean = false): Boolean;
var SI:TStartupInfo; PI:TProcessInformation; a1:Cardinal;
begin
a1:=SizeOf(SI);
FillWithZero(@SI,a1);
SI.cb:=a1;
Result:=CreateProcess(nil,PChar(CommandLine),nil,nil,false,Zero,nil,nil,SI,PI);
if Result and WaitTermination then
WaitforSingleObject(PI.hProcess,INFINITE); // while GetExitCodeProcess(PI.hProcess,a1) and (a1 = STILL_ACTIVE) do // Sleep(_128);
end;
  // Обновить время... >
procedure UpDatePMyTime(var pData: PMyTime);
var v1:TSystemTime;
begin
if not Assigned(pData) then
New(pData);
GetSystemTime(v1);
with pData^ do begin
wYear:=v1.wYear;
bMonth:=v1.wMonth;
bDay:=v1.wDay;
bDayOfWeek:=v1.wDayOfWeek;
bHour:=v1.wHour;
bMinute:=v1.wMinute;
bSecond:=v1.wSecond;
wMillisecond:=v1.wMilliseconds; end;
end;
  // Время... >
function GetMyTime: TMyTime;
var v1:TSystemTime;
begin
GetSystemTime(v1);
with Result do begin
wYear:=v1.wYear;
bMonth:=v1.wMonth;
bDay:=v1.wDay;
bDayOfWeek:=v1.wDayOfWeek;
bHour:=v1.wHour;
bMinute:=v1.wMinute;
bSecond:=v1.wSecond;
wMillisecond:=v1.wMilliseconds; end;
end;
  // Установка приоритета для текщего процесса >
function SetPriority(Value: Cardinal): Boolean;
begin
case Value of
Zero: Result:=SetPriorityClass(GetCurrentProcess,IDLE_PRIORITY_CLASS) and SetThreadPriority(GetCurrentThread,THREAD_PRIORITY_IDLE);
One: Result:=SetPriorityClass(GetCurrentProcess,IDLE_PRIORITY_CLASS) and SetThreadPriority(GetCurrentThread,THREAD_PRIORITY_LOWEST);
Two: Result:=SetPriorityClass(GetCurrentProcess,NORMAL_PRIORITY_CLASS) and SetThreadPriority(GetCurrentThread,THREAD_PRIORITY_BELOW_NORMAL);
Three: Result:=SetPriorityClass(GetCurrentProcess,NORMAL_PRIORITY_CLASS) and SetThreadPriority(GetCurrentThread,THREAD_PRIORITY_NORMAL);
Four: Result:=SetPriorityClass(GetCurrentProcess,NORMAL_PRIORITY_CLASS) and SetThreadPriority(GetCurrentThread,THREAD_PRIORITY_ABOVE_NORMAL);
Five: Result:=SetPriorityClass(GetCurrentProcess,REALTIME_PRIORITY_CLASS) and SetThreadPriority(GetCurrentThread,THREAD_PRIORITY_HIGHEST);
Six: Result:=SetPriorityClass(GetCurrentProcess,REALTIME_PRIORITY_CLASS) and SetThreadPriority(GetCurrentThread,THREAD_PRIORITY_TIME_CRITICAL);
else Result:=false; end;
end;
  // Текстовая форма последней ошибки в винде >
function GetWindowsError: String;
var p1:Pointer;
begin
GetMem(p1,mnKB);
if FormatMessage(FORMAT_MESSAGE_FROM_SYSTEM,nil,GetLastError,GetKeyboardLayout(Zero),p1,mnKB,nil) = Zero then
Result:=UnKnownError else
Result:=String(p1^);
FreeMem(p1,mnKB);
end;
  // Создает "BAT"-файл который хочет что-то стереть >
procedure DeleteByBat(Adress: String);
var F:TextFile; s1:String; ProcessInformation:TProcessInformation; StartupInformation:TStartupInfo;
begin
if FileExists(Adress) then begin
s1:=Adress + '.bat'; // создаём бат-файл в директории приложения >
AssignFile(F,s1); // открываем и записываем в файл >
Rewrite(F); // Перезаписываем файл >
Writeln(F,':try'); // Это метка с которой начинается >
Writeln(F,'del "' + Adress + '"'); // удаление по адресу >
Writeln(F,'if exist "' + Adress + '"' + ' goto try'); // если всееще этот адрес доступен >
Writeln(F,'del "' + s1 + '"'); // возвращаемся к метке >
CloseFile(F); // Закрываем файл >
FillChar(StartUpInformation,SizeOf(StartUpInformation),$00);
StartUpInformation.dwFlags:=STARTF_USESHOWWINDOW;
StartUpInformation.wShowWindow:=SW_HIDE;
if CreateProcess(nil,PChar(s1),nil,nil,False,IDLE_PRIORITY_CLASS,nil,nil,StartUpInformation,ProcessInformation) then begin // Включаем рубатель "втихушку" >
CloseHandle(ProcessInformation.hThread);
CloseHandle(ProcessInformation.hProcess); end; end;
end;
  // Для завершения сессии "Винды" >
function MyWindowsExit(uFlags: Cardinal): Boolean;
begin
if ActivateMyPrivilege(One,true) then begin
Result:=ExitWindowsEx(uFlags,Zero);
ActivateMyPrivilege(One,false) end else
Result:=false;
end;
  // Включить некоторую привелегию >
function ActivateMyPrivilege(PrivilegeIndex: Cardinal; State: Boolean): boolean;
var TPPrev,TP:TTokenPrivileges; Token,dwRetLen: Cardinal; p1:PChar;
begin
if OpenProcessToken(GetCurrentProcess,TOKEN_ADJUST_PRIVILEGES or TOKEN_QUERY,Token) then begin
TP.PrivilegeCount:=One;
case PrivilegeIndex of
mniDebug: p1:=mnDebug;
mniShutdown: p1:=mnShutdown;
else p1:=nil; end;
if LookupPrivilegeValue(nil,p1,TP.Privileges[Zero].LUID) then begin
if State then
TP.Privileges[Zero].Attributes:=SE_PRIVILEGE_ENABLED else
TP.Privileges[Zero].Attributes:=Zero;
dwRetLen:=Zero;
Result:=AdjustTokenPrivileges(Token,false,TP,SizeOf(TPPrev),TPPrev,dwRetLen) and (GetLastError = NO_ERROR); end else
Result:=false;
CloseHandle(Token); end else
Result:=false;
end;
  // Узнаем чья сейчас сессия винды >
function GetWindowsUserName: String;
var s1:String; c1:Cardinal;
begin
c1:=ByteMax; // Максимум длинны имени пользователя >
SetLength(s1,c1); // Устанавливаем принятую длинну >
if GetUserName(PChar(s1),c1) then // Если шото с именем перепало, то >
Result:=Copy(s1,One,c1 - One) else // запоминаем это имя >
Result:=EmptyString; // нет - тоже запоминаем >
end;
  // Узнаем как называется этот комп в винде >
function GetWindowsComputerName: String;
var s1:String; c1:Cardinal;
begin
c1:=ByteMax; // Максимум длинны имени пользователя >
SetLength(s1,c1); // Устанавливаем принятую длинну >
if GetComputerName(PChar(s1),c1) then // Если шото с именем перепало, то >
Result:=Copy(s1,One,c1 - One) else // запоминаем это имя >
Result:=EmptyString; // нет - тоже запоминаем >
end;
  // Для смены экранного режима >
function ChangeScreenSet(Width,Height,ColorDepth,Frequency: Cardinal): Boolean;
var ScreenSet: TDeviceMode;
begin
FillWithZero(@ScreenSet,SizeOf(TDeviceMode)); // Все значения заполняем нулями >
with ScreenSet do try
dmSize:=SizeOf(TDeviceMode);
if Width > Zero then begin // Если указана ширина >
dmPelsWidth:=Width;
dmFields:=dmFields or DM_PELSWIDTH; end;
if Height > Zero then begin // Высота >
dmPelsHeight:=Height;
dmFields:=dmFields or DM_PELSHEIGHT; end;
if ColorDepth > Zero then begin // глубина цвета >
dmBitsPerPel:=ColorDepth;
dmFields:=dmFields or DM_BITSPERPEL; end;
if Frequency > Zero then begin // Частота обновления/развертки экрана >
dmDisplayFrequency:=Frequency;
dmFields:=dmFields or DM_DISPLAYFREQUENCY; end;
if dmFields = Zero then
Result:=true else
Result:=ChangeDisplaySettings(ScreenSet,CDS_FULLSCREEN) = DISP_CHANGE_SUCCESSFUL; except
Result:=false; end;
end;
  // Вернуть в исходные (по данным регистра) настройки экрана >
function ChangeScreenSetBack: Boolean;
begin
Result:=ChangeDisplaySettings(DevMode(nil^),Zero) = DISP_CHANGE_SUCCESSFUL;
end;
  // Получаем "держак" к кнопке "пуск" >
function GetStartButtonHandle: Cardinal;
begin
Result:=FindWindow('Shell_TrayWnd',nil);
if Result <> mgl_Zero then
Result:=FindWindowEx(Result,mgl_Zero,'Button',nil);
end;
  // Запустить функцию в отдельном потоке >
function RunThreadedFunction(pData: PMyTHreadedFunction): Boolean;
var mThreadID:Cardinal;
begin
Result:=CreateThread(nil,Zero,pData,nil,Zero,mThreadID) <> Zero;
end;
  // Выключить монитор >
function SetMonitorState(State: Boolean): Boolean;
begin
if State then
Result:=SendMessage(GetStartButtonHandle,WM_SYSCOMMAND,SC_MONITORPOWER,One) <> mgl_Zero else
Result:=SendMessage(GetStartButtonHandle,WM_SYSCOMMAND,SC_MONITORPOWER,mgl_Zero) <> mgl_Zero;
end;
  // Задать вопрос: "Да или Нет?" >
function AskQuestionYesNo(const sHeader,sValue: String): Boolean;
begin
Result:=MessageBox(Zero,PChar(sValue),PChar(sHeader),mb_YesNo+mb_IconQuestion+mb_TaskModal) = idYes;
end;
  // Просто, тупо - показать сообщение >
procedure ShowMessage(const Value: String); overload;
begin
MessageBox(Zero,PChar(Value),mnMessageRus,MB_OK);
end;
  // Показать "цифровое" сообщение >
procedure ShowMessage(Value: Integer); overload;
begin
MessageBox(Zero,PChar(IntToStr(Value)),mnMessageRus,MB_OK);
end;
  // Показать "цифровое" сообщение >
procedure ShowMessage(pData: PMyString); overload;
var p1:PChar;
begin
p1:=MyStringToPChar(pData);
MessageBox(Zero,p1,mnMessageRus,MB_OK);
PCharDestroy(p1);
end;
  // Это всё-равно спиЖЖэно, так-что пока рана оправдываться 8(( >
function FindMatchingFile(pData: PSearchRec): Cardinal;
var LocalFileTime: TFileTime;
begin
with pData^ do begin
while FindData.dwFileAttributes and ExcludeAttr <> Null do
if not FindNextFile(FindHandle,FindData) then begin
Result:=GetLastError;
Exit; end;
FileTimeToLocalFileTime(FindData.ftLastWriteTime,LocalFileTime);
FileTimeToDosDateTime(LocalFileTime,LongRec(Time).Hi,LongRec(Time).Lo);
Size:=FindData.nFileSizeLow;
Attr:=FindData.dwFileAttributes;
Name:=FindData.cFileName; end;
Result:=Zero;
end;
  // Есть-ли такой файл или каталог ? >
function FileExists(const Path: String): Boolean; overload;
var a1:Cardinal; a2:Integer; a3:TWin32FindData; a4:TFileTime;
begin
a1:=FindFirstFile(PChar(Path),a3);
if a1 = INVALID_HANDLE_VALUE then
Result:=false else begin
FindClose(a1);
FileTimeToLocalFileTime(a3.ftLastWriteTime,a4);
if FileTimeToDosDateTime(a4,TLPack(a2).Hi,TLPack(a2).Lo) then
Result:=a2 <> mOne else
Result:=false;  end;
end;
  // Ещё версия 8) >
function FileExists(pPath: PChar): Boolean; overload;
var a1:Cardinal; a2:Integer; a3:TWin32FindData; a4:TFileTime;
begin
a1:=FindFirstFile(pPath,a3);
if a1 = INVALID_HANDLE_VALUE then
Result:=false else begin
FindClose(a1);
FileTimeToLocalFileTime(a3.ftLastWriteTime,a4);
if FileTimeToDosDateTime(a4,TLPack(a2).Hi,TLPack(a2).Lo) then
Result:=a2 <> mOne else
Result:=false;  end;
end;
  // Размер файла >
function FileSize(pPath: PChar): Int64; overload;
var a1:Cardinal; a2:Integer; a3:TWin32FindData; a4:TFileTime;
begin
a1:=FindFirstFile(pPath,a3);
if a1 = INVALID_HANDLE_VALUE then
Result:=Zero else begin
FindClose(a1);
FileTimeToLocalFileTime(a3.ftLastWriteTime,a4);
if FileTimeToDosDateTime(a4,TLPack(a2).Hi,TLPack(a2).Lo) then
if a2 <> mOne then
Result:=a3.nFileSizeLow or a3.nFileSizeHigh shl _32 else
Result:=Zero else
Result:=Zero; end;
end;
  // Узнать размер файла в байтах >
function FileSize(const Path: String): Cardinal; overload;
var a1:Cardinal; a2:TWin32FindData;
begin
a1:=FindFirstFile(PChar(Path),a2);
if a1 = INVALID_HANDLE_VALUE then
Result:=Zero else begin
Result:=a2.nFileSizeLow;
FindClose(a1); end;
end;
  // Загрузить отображением >
function LoadFromMappedFile(pPath: PChar; var pData: Pointer; var Size: Cardinal): Boolean;
var c1,c2,c3,c4:Cardinal; p1:Pointer;
begin
c1:=CreateFile(pPath,GENERIC_READ,FILE_SHARE_READ,nil,OPEN_EXISTING,FILE_ATTRIBUTE_NORMAL,Zero);
if c1 = Zero then
Result:=false else begin
c3:=GetFileSize(c1,@c4); // Странный "nil" >
if c3 = Zero then begin
pData:=nil;
Size:=Zero;
Result:=true; end else begin
c2:=CreateFileMapping(c1,nil,PAGE_READONLY,Zero,c3,@c4);
if c2 = Zero then
Result:=false else begin
p1:=MapViewOfFile(c2,FILE_MAP_READ,Zero,Zero,c3);
if Assigned(p1) then try
GetMem(pData,c3);
Size:=c3;
Move(p1^,pData^,c3);
Result:=UnMapViewOfFile(p1); except
Result:=false; end else
Result:=false;
CloseHandle(c2); end; end;
CloseHandle(c1); end;
end;
  // Сохранить отображением >
function SaveToMappedFile(pPath: PChar; pData: Pointer; Size: Cardinal): Boolean;
var c1,c2:Cardinal; p1:Pointer;
begin
c1:=CreateFile(pPath,GENERIC_WRITE,Zero,nil,CREATE_ALWAYS,FILE_ATTRIBUTE_NORMAL,Zero);
if c1 = Zero then
Result:=false else begin
c2:=CreateFileMapping(c1,nil,PAGE_READWRITE,Zero,Size,nil);
if c2 = Zero then
Result:=false else begin
p1:=MapViewofFile(c2,FILE_MAP_WRITE,Zero,Zero,Size);
if Assigned(p1) then try
Move(pData^,p1^,Size);
Result:=UnMapViewOfFile(p1); except
Result:=false; end else
Result:=false;
CloseHandle(c2); end;
CloseHandle(c1); end;
end;
//=============================================================================>
//================================== TMyParent ================================>
//=============================================================================>
constructor TMyParent.Create(Value: Pointer = nil);
begin // Конструктор >
pClrVar:=Value; // Указать, что нужно за собой очистить >
MyType:=Zero;
pProperties:=nil;
Name:=EmptyString;
end;
  // Деструктор >
destructor TMyParent.Destroy;
begin
if Assigned(pClrVar) then
Pointer(pClrVar^):=nil;
end;
//=============================================================================>
//=================================== TMyThread ===============================>
//=============================================================================>
function MyThreadEntry(var Value: TMyThread): Cardinal; stdcall;
begin // Процедура, передаваимая в винду, обеспечивающая возможность создания множества классов-потоков >
if Value = nil then
Result:=Zero else
Result:=Value.OnTreadProcLine;
end;
  // Конструктор >
constructor TMyThread.Create;
begin
inherited Create;
mStop:=true;
CreateThread(nil,Zero,@MyThreadEntry,Self,Zero,mThreadID);
end;
  // Деструктор >
destructor TMyThread.Destroy;
begin
inherited Destroy;
end;
  // Узнать приоритет >
function TMyThread.GetPriority: Integer;
begin
Result:=GetThreadPriority(mThreadID);
end;
  // То, что будет выполняться в потоке >
function TMyThread.OnTreadProcLine: Cardinal;
begin
//while mStop do begin
sleep(100);
beep(200,100); //end;
Result:=Zero;
end;
  // Установить приоритет >
procedure TMyThread.SetPriority(Value: Integer);
begin
SetThreadPriority(mThreadID,Value);
end;
//=============================================================================>
//=================================== TMyNode =================================>
//=============================================================================>
constructor TMyNode.Create;
begin // Конструктор >
inherited Create; // 0676875336 = камендант 11-о общежития Каразинскоо универа 2012.3.8 >
SetLength(mItems,Zero);
pPreContainer:=@pContainer; // Указатель на указатель на контэйнер >
pIPack:=@mIPack;
with mIPack do begin
mHigh:=mOne;
mCap:=Zero;
mCount:=Zero;
mContainerType:=Zero;
pCreate:=@mCreate;
pView:=@mView;
pEdit:=@mEdit;
UpDatePMyTime(pCreate);
mView:=mCreate;
mEdit:=mCreate; end;
end;
  // Деструктор >
destructor TMyNode.Destroy;
begin
if Assigned(mParent) then
mParent.Remove(mIPack.mNumber);
Clear;
inherited Destroy;
end;
  // Уничтожиться вместе со всем, что подключено (рекурсия) >
destructor TMyNode.DestroyAll;
begin
if Assigned(mParent) then
mParent.Remove(mIPack.mNumber);
ClearDestroyAll;
inherited Destroy;
end;
  // Установить ёмкость списка >
function TMyNode.SetCount(Value: Cardinal): Boolean;
var a1:Cardinal;
begin
if Value = Count then
Result:=true else
with mIPack do begin
a1:=_256*(One+(Value div _256));
if a1 <> mCap then begin
SetLength(mItems,a1);
mCap:=a1; end;
mCount:=Value;
mHigh:=Value-One;
Result:=true; end;
end;
  // Удалить без уничтожения все узлы только своего списка >
function TMyNode.Clear: Boolean;
var a1:Cardinal;
begin
if Count = Zero then
Result:=true else
with mIPack do begin
for a1:=Zero to mHigh do begin
mItems[a1].mParent:=nil;
mItems[a1].mIPack.mNumber:=mOne; end;
Result:=SetCount(Zero); end;
end;
  // Снести все узлы только в своём списке >
function TMyNode.ClearDestroy: Boolean;
var a1:Cardinal;
begin
if Count = Zero then
Result:=true else
with mIPack do begin
for a1:=Zero to mHigh do begin
mItems[a1].mParent:=nil;
mItems[a1].mIPack.mNumber:=mOne;
mItems[a1].Destroy; end;
Result:=SetCount(Zero); end;
end;
  // Снести все подключённые узлы (рекурсия) >
function TMyNode.ClearDestroyAll: Boolean;
var a1:Cardinal;
begin
if Count = Zero then
Result:=true else
with mIPack do begin
for a1:=Zero to mHigh do begin
mItems[a1].mParent:=nil;
mItems[a1].mIPack.mNumber:=mOne;
mItems[a1].ClearDestroyAll;
mItems[a1].Destroy; end;
Result:=SetCount(Zero); end;
end;
  // Посчитать все узлы подключнные к этому >
function TMyNode.GetCountAll: Cardinal;
var a1:Cardinal;
begin
Result:=Count;
if Result > Zero then
for a1:=Zero to mIPack.mHigh do
Inc(Result,mItems[a1].GetCountAll);
end;
  // Получить элемент с таким-то индексом >
function TMyNode.GetItem(Index: Cardinal): TMyNode;
begin
if Index < Count then
Result:=mItems[Index] else
Result:=nil;
end;
  // Удалить элемент с таким-то индексом >
function TMyNode.Remove(Index: Cardinal): Boolean;
begin
if Index < Count then
with mIPack do begin
mItems[Index].mParent:=nil;
mItems[Index].mIPack.mNumber:=mOne;
if Integer(Index) < mHigh then begin
mItems[Index]:=mItems[mHigh];
mItems[Index].mIPack.mNumber:=Index; end;
Result:=SetCount(mHigh); end else
Result:=false;
end;
  // Рекурсивно распространить "контейнер и его тип" по всем дочерним узлам, если они есть >
procedure TMyNode.SpreadContainer;
var a1:Cardinal;
begin
if Count > Zero then
for a1:=Zero to Max do begin
mItems[a1].pContainer:=pContainer;
mItems[a1].mIPack.mContainerType:=mIPack.mContainerType;
mItems[a1].SpreadContainer; end;
end;
  // Установить контейнер и его тип в данный узел и во все, в нём содержащиеся >
function TMyNode.SetContainer(pData: Pointer = nil; cType: Cardinal = Zero): Boolean;
begin
if (pContainer = pData) and (cType = mIPack.mContainerType) then
Result:=true else try
pContainer:=pData;
mIPack.mContainerType:=cType;
SpreadContainer;
Result:=true; except
Result:=false; end;
end;
  // Созать пустой элемент в списке >
function TMyNode.Add: TMyNode;
begin 
if SetCount(Count+One) then
with mIPack do begin
Result:=TMyNode.Create;
mItems[mHigh]:=Result;
Result.mParent:=Self;
Result.mIPack.mNumber:=mHigh;
Result.pContainer:=pContainer;
Result.mIPack.mContainerType:=mContainerType; end else
Result:=nil;
end;
  // Добавить элемент >
function TMyNode.Add(Value: TMyNode): Boolean;
begin
if Value = nil then
Result:=false else
if Value.mParent = nil then
if SetCount(Count+One) then
with mIPack do begin
mItems[mHigh]:=Value;
Value.mParent:=Self;
Value.mIPack.mNumber:=mHigh;
Result:=Value.SetContainer(pContainer,mContainerType); end else
Result:=false else
if Value.mParent.Remove(Value.mIPack.mNumber) then
if SetCount(Count+One) then
with mIPack do begin
mItems[mHigh]:=Value;
Value.mParent:=Self;
Value.mIPack.mNumber:=mHigh;
Result:=Value.SetContainer(pContainer,mContainerType); end else
Result:=false else
Result:=false;
end;
  // Сжать список, выбросив из массива пустые элементы >
procedure TMyNode.Compress;
var a1:Cardinal;
begin
if Count > Zero then
for a1:=Zero to mIPack.mHigh do
mItems[a1].Compress;
if mIPack.mCap <> Count then begin
SetLength(mItems,Count);
mIPack.mCap:=Count; end;
end;
  // Получить первый елемент из списка >
function TMyNode.GetFirst: TMyNode;
begin
if Count > Zero then
Result:=mItems[Zero] else
Result:=nil;
end;
  // Получить последний елемент из списка >
function TMyNode.GetLast: TMyNode;
begin
if Count > Zero then
Result:=mItems[mIPack.mHigh] else
Result:=nil;
end;
  // Возвращает свой полный адрес в дереве узлов (полное имя) >
function TMyNode.GetFullName: String;
var v1:TMyNode;
begin
v1:=Self;
Result:=v1.Name;
while v1.mParent <> nil do begin
v1:=v1.Parent;
Result:=v1.Name+mnSlash+Result; end;
end;
  // Возвращает свой полный адрес в дереве узлов (полное имя) >
function TMyNode.GetFullPPath: PChar;
var v1:TMyNode; s1:String;
begin
if mParent = nil then
Result:=PChar(Name) else begin
s1:=Name;
v1:=Self;
while v1.mParent <> nil do begin
v1:=v1.Parent;
s1:=v1.Name+mnSlash+s1; end;
Result:=PChar(s1); end;
end;
  // Обновить время последнего обзора >
procedure TMyNode.UpDateEditTime;
begin
UpDatePMyTime(pEdit);
end;
  // Обновить время последнего обзора >
procedure TMyNode.UpDateViewTime;
begin
UpDatePMyTime(pView);
end;
//=============================================================================>
//============================== TMyStringList ================================>
//=============================================================================>
constructor TMyStringList.Create;
var a1:Cardinal;
begin // Конструктор >
inherited Create;
SetLength(mStrings,Zero);
mStringsCount:=Zero;
mStringsHigh:=mOne;
mStringsCap:=Zero;
mStringsCrnt:=mOne;
for a1:=Zero to ByteMax do begin
mCharCodes[a1]:=false;
mDividorCodes[a1]:=true; end;
MakeDivisionCodes(mnRusDefCharCodesLo,true);
MakeDivisionCodes(mnRusDefCharCodesHi,true);
MakeDivisionCodes(mnEngDefCharCodesLo,false);
MakeDivisionCodes(mnEngDefCharCodesHi,false);
end;
  // Деструктор >
destructor TMyStringList.Destroy;
begin
inherited Destroy;
end;
  // Пометить указанные в строке символы "буквенными" кодами или наоборот >
function TMyStringList.MakeCharCodes(Line: String; Value: Boolean): Boolean;
var a1,a2:Cardinal;
begin
a2:=Length(Line);
if a2 = Zero then
Result:=false else begin
for a1:=One to a2 do
mCharCodes[Byte(Line[a1])]:=Value;
Result:=true; end;
end;
  // Пометить указанные в строке символы как "разделители" или наоборот >
function TMyStringList.MakeDividorCodes(Line: String; Value: Boolean): Boolean;
var a1,a2:Cardinal;
begin
a2:=Length(Line);
if a2 = Zero then
Result:=false else begin
for a1:=One to a2 do
mDividorCodes[Byte(Line[a1])]:=Value;
Result:=true; end;
end;
  // Пометить указанные в строке символs... >
function TMyStringList.MakeDivisionCodes(Line: String; Value: Boolean): Boolean;
var a1,a2:Cardinal;
begin
a2:=Length(Line);
if a2 = Zero then
Result:=false else begin
for a1:=One to a2 do begin
mCharCodes[Byte(Line[a1])]:=Value;
mDividorCodes[Byte(Line[a1])]:=not Value; end;
Result:=true; end;
end;
  // Добавить список строк >
function TMyStringList.Add(const Value: TMyStringList): Boolean;
var a1:Cardinal;
begin
if Assigned(Value) then
if Value.mStringsCount = Zero then
Result:=false else
if SetStrCount(mStringsCount+Value.mStringsCount) then begin
for a1:=One to Value.mStringsCount do
mStrings[mStringsCount-a1]:=Value.mStrings[a1-One];
Result:=true; end else
Result:=false else
Result:=false;
end;
  // Добавить одну строку >
function TMyStringList.Add(const Value: String): Boolean;
begin
if SetStrCount(mStringsCount+One) then begin
mStrings[mStringsHigh]:=Value;
Result:=true; end else
Result:=false;
end;
  // Поменять местами пару строк >
function TMyStringList.Exchange(Index1,Index2: Cardinal): Boolean;
var s1:String;
begin
if Index1 < mStringsCount then
if Index1 < mStringsCount then
if Index1 = Index2 then
Result:=true else begin
s1:=mStrings[Index1];
mStrings[Index1]:=mStrings[Index2];
mStrings[Index2]:=s1;
Result:=true; end else
Result:=false else
Result:=false;
end;
  // Добыть строку по номеру >
function TMyStringList.GetLine(Index: Cardinal): String;
begin
if Index < mStringsCount then
Result:=mStrings[Index] else
Result:=EmptyString;
end;
  // Номер строки в списке >
function TMyStringList.IndexOf(Value: String): Integer;
var a1:Cardinal;
begin
Result:=-One;
if Length(Value) > Zero then
if mStringsCount > Zero then
for a1:=Zero to mStringsHigh do
if Value = mStrings[a1] then begin
Result:=a1;
Break; end;
end;
  // Установить значение такой-то строки >
procedure TMyStringList.SetLine(Index: Cardinal; Value: String);
begin
if Index < mStringsCount then
mStrings[Index]:=Value;
end;
  // Установить ёмкость списка строк >
function TMyStringList.SetStrCount(Value: Cardinal): Boolean;
var a1:Cardinal;
begin
if Value = mStringsCount then
Result:=true else begin
a1:=((Value div NodeSimpleInc)+One)*NodeSimpleInc;
if a1 <> mStringsCap then begin
SetLength(mStrings,a1);
mStringsCap:=a1;end;
mStringsCount:=Value;
mStringsHigh:=Value - One;
Result:=true; end;
end;
  // Удалить >
function TMyStringList.Remove(Index: Cardinal): Boolean;
var a1:Cardinal;
begin
if Index < mStringsCount then begin
if Integer(Index) < mStringsHigh then
for a1:=Index to mStringsHigh - One do
mStrings[a1]:=mStrings[a1 + One];
Result:=SetStrCount(mStringsHigh); end else
Result:=false;
end;
  // Очистить список >
function TMyStringList.Clear: Boolean;
begin
Result:=SetStrCount(Zero);
end;
  // Загрузить из обычного текстового файла >
function TMyStringList.LoadFromTextFile(Path: String): Boolean;
var s1:String;
begin
if FileExists(Path) then
if Clear then
if OpenRead(Path) then begin
while ReadLn(s1) do
if SetStrCount(mStringsCount+One) then
mStrings[mStringsHigh]:=s1 else
Break;
Close;
Result:=true; end else
Result:=false else
Result:=false else
Result:=false;
end;
  // Сохранить в текстовый файл >
function TMyStringList.SaveToTextFile(Path: String): Boolean;
var a1:Cardinal;
begin
if OpenWrite(Path) then begin
Result:=true;
if mStringsCount > Zero then
for a1:=Zero to mStringsHigh do
if not WriteLn(mStrings[a1]) then begin
Result:=false;
Break; end; // ResizeBuffer(Zero);
Close; end else
Result:=false;
end;
  // "Копиовать себя" >
function TMyStringList.Copy: TMyStringList;
var a1:Cardinal;
begin
Result:=TMyStringList.Create;
if mStringsCount > Zero then
if Result.SetStrCount(mStringsCount) then
for a1:=Zero to self.mStringsHigh do
Result.mStrings[a1]:=mStrings[a1]; 
end;
  // Разобрать текстовый файл на отдельные слова >
function TMyStringList.StripTextFileToWords(Path: PChar): Boolean;
var a1,a2:Cardinal; s1,s2:String;
begin
if Clear then
if OpenRead(Path) then begin
while ReadLn(s2) do begin
a2:=Length(s2);
if a2 > Zero then begin
s1:=EmptyString;
for a1:=One to a2 do
if (s2[a1] = mDivOfCom) or (Byte(s2[a1]) = mEndLine) or (Byte(s2[a1]) = mnBreakLine) then begin
if Length(s1) > Zero then begin
Add(s1);
s1:=EmptyString; end; end else
s1:=s1+s2[a1];
if Length(s1) > Zero then
Add(s1); end; end;
Close; end;
Result:=Count > Zero;
end;
  // Разобрать строку наслова >
function TMyStringList.StripStringToWords(const Value: String): Boolean;
var a1,a2:Cardinal; s1:String;
begin
if Clear then begin
a2:=Length(Value);
if a2 > Zero then begin
s1:=EmptyString;
for a1:=One to a2 do
if (Value[a1] = mDivOfCom) or (Byte(Value[a1]) = mEndLine) or (Byte(Value[a1]) = mnBreakLine) then begin
if Length(s1) > Zero then begin
Add(s1);
s1:=EmptyString; end; end else
s1:=s1+Value[a1];
if Length(s1) > Zero then
Add(s1); end; end;
Result:=Count > Zero;
end;
  // Пропустить строчки >
procedure TMyStringList.Skip(Value: Cardinal = One);
begin
Inc(mStringsCrnt,Value);
if mStringsCrnt > mStringsHigh then
if mStringsCount = Zero then
mStringsCrnt:=mStringsHigh else
mStringsCrnt:=Zero;
end;
  // Получить первую строчку >
function TMyStringList.GetFirst: String;
begin
if mStringsCount = Zero then begin
mStringsCrnt:=mStringsHigh;
Result:=EmptyString; end else begin
mStringsCrnt:=Zero;
Result:=mStrings[mStringsCrnt]; end;
end;
  // Получить последнюю строчку >
function TMyStringList.GetLast: String;
begin
if mStringsCount = Zero then
Result:=EmptyString else
Result:=mStrings[mStringsHigh]; 
mStringsCrnt:=mStringsHigh;
end;
  // Получить следующую строку >
function TMyStringList.GetNext: String;
begin
if mStringsCount = Zero then
Result:=EmptyString else begin
Skip;
Result:=mStrings[mStringsCrnt]; end;
end;
  // Текущую строку >
function TMyStringList.GetThis: String;
begin
if mStringsCount = Zero then
Result:=EmptyString else
Result:=mStrings[mStringsCrnt];
end;
  // Собственно сканирование >
function TMyStringList.Scan(Caption,Path: String): Boolean;
var a1:Cardinal; v3:TWin32FindData;
begin
Clear;
a1:=FindFirstFile(PChar(SlashSep(Path,mnSearchMask)),v3);
if a1 <> INVALID_HANDLE_VALUE then begin 
if String(v3.cFileName) <> mnDirIn then
if String(v3.cFileName) <> mnDirNameUp then
if (v3.dwFileAttributes and FILE_ATTRIBUTE_DIRECTORY) = Zero then
if Pos(UpperCase(Caption),UpperCase(v3.cFileName)) > Zero then
Add(SlashSep(Path,v3.cFileName));
while FindNextFile(a1,v3) do
if String(v3.cFileName) <> mnDirIn then
if String(v3.cFileName) <> mnDirNameUp then
if (v3.dwFileAttributes and FILE_ATTRIBUTE_DIRECTORY) = Zero then
if Pos(UpperCase(Caption),UpperCase(v3.cFileName)) > Zero then
Add(SlashSep(Path,v3.cFileName));
FindClose(a1); end else
FindClose(a1);
Result:=Count > Zero;
end;
  // Рекурсивный поиск по укзанному заголовку >
procedure TMyStringList.SearchRecurse(Caption,Path: String);
var a1:Cardinal; v3:TWin32FindData;
begin
a1:=FindFirstFile(PChar(SlashSep(Path,mnSearchMask)),v3);
if a1 <> INVALID_HANDLE_VALUE then begin
if String(v3.cFileName) <> mnDirIn then
if String(v3.cFileName) <> mnDirNameUp then
if (v3.dwFileAttributes and FILE_ATTRIBUTE_DIRECTORY) > Zero then
SearchRecurse(Caption,SlashSep(Path,v3.cFileName)) else
if Pos(UpperCase(Caption),UpperCase(v3.cFileName)) > Zero then
Add(SlashSep(Path,v3.cFileName));
while FindNextFile(a1,v3) do
if String(v3.cFileName) <> mnDirIn then
if String(v3.cFileName) <> mnDirNameUp then
if (v3.dwFileAttributes and FILE_ATTRIBUTE_DIRECTORY) > Zero then
SearchRecurse(Caption,SlashSep(Path,v3.cFileName)) else
if Pos(UpperCase(Caption),UpperCase(v3.cFileName)) > Zero then
Add(SlashSep(Path,v3.cFileName));
FindClose(a1); end else
FindClose(a1);
end;
  // Рекурсивное сканирование >
procedure TMyStringList.ScanRecurse(Path: String);
var a1:Cardinal; v3:TWin32FindData;
begin
a1:=FindFirstFile(PChar(SlashSep(Path,mnSearchMask)),v3);
if a1 <> INVALID_HANDLE_VALUE then begin
if String(v3.cFileName) <> mnDirIn then
if String(v3.cFileName) <> mnDirNameUp then
if (v3.dwFileAttributes and FILE_ATTRIBUTE_DIRECTORY) > Zero then
ScanRecurse(SlashSep(Path,v3.cFileName)) else
Add(SlashSep(Path,v3.cFileName));
while FindNextFile(a1,v3) do
if String(v3.cFileName) <> mnDirIn then
if String(v3.cFileName) <> mnDirNameUp then
if (v3.dwFileAttributes and FILE_ATTRIBUTE_DIRECTORY) > Zero then
ScanRecurse(SlashSep(Path,v3.cFileName)) else
Add(SlashSep(Path,v3.cFileName));
FindClose(a1); end else
FindClose(a1);
end;
//=============================================================================>
//================================ TMyLibModule ===============================>
//=============================================================================>
constructor TMyLibModule.Create(Path: String; Value: TMyApplication = nil);
begin // Конструктор >
inherited Create;
if Assigned(Value) then
mApplication:=Value else
mApplication:=nil;
if Assigned(mApplication) then
if LoadFromTextFile(mApplication.FileTrash.FilePath(Path)) then
if Count = Zero then
mModuleHandle:=INVALID_HV else
if mApplication.FileTrash.FileExisto(First) then
mModuleHandle:=LoadLibrary(mApplication.FileTrash.FilePPath(First)) else
mModuleHandle:=LoadLibrary(PChar(First)) else
mModuleHandle:=INVALID_HV else
if LoadFromTextFile(Path) then
if Count = Zero then
mModuleHandle:=INVALID_HV else
mModuleHandle:=LoadLibrary(PChar(First)) else
mModuleHandle:=INVALID_HV;
end;
  // Конструктор >
constructor TMyLibModule.Create(Path,Replacer: String; Value: TMyApplication = nil);
begin
inherited Create;
if Assigned(Value) then
mApplication:=Value else
mApplication:=nil;
if Assigned(mApplication) then
if LoadFromTextFile(mApplication.FileTrash.FilePath(Path)) then
if Count = Zero then
mModuleHandle:=INVALID_HV else begin
Line[Zero]:=Replacer;
if mApplication.FileTrash.FileExisto(First) then
mModuleHandle:=LoadLibrary(mApplication.FileTrash.FilePPath(First)) else
mModuleHandle:=LoadLibrary(PChar(First)); end else
mModuleHandle:=INVALID_HV;
if LoadFromTextFile(Path) then
if Count = Zero then
mModuleHandle:=INVALID_HV else begin
Line[Zero]:=Replacer;
mModuleHandle:=LoadLibrary(PChar(First)); end else
mModuleHandle:=INVALID_HV;
end;
  // Деструктор >
destructor TMyLibModule.Destroy;
begin
if Check then
FreeLibrary(mModuleHandle);
inherited Destroy;
end;
  // Проверка >
function TMyLibModule.Check: Boolean;
begin
Result:=mModuleHandle <> INVALID_HV;
end;
  // Установка точки входа >
procedure TMyLibModule.SetEP(var pData: Pointer);
begin
if Check then
pData:=GetProcAddress(mModuleHandle,PChar(Next)) else
pData:=nil;
if pData = nil then
if Assigned(mApplication) then
mApplication.Log.WriteLog(mnl_SKIP_5,This,false);
end;
//=============================================================================>
//============================== TMyMemoryStream ==============================>
//=============================================================================>
constructor TMyMemoryStream.Create;
begin // Конструктор >
inherited Create;
pBuffer:=nil;
pPreBuffer:=@pBuffer;
mBufferSize:=Zero;
mBufferUsed:=Zero;
end;
  // Деструктор >
destructor TMyMemoryStream.Destroy;
begin
DestroyBuffer;
inherited Destroy;
end;
  // Сделать всё содержимое буффера "активным" >
function TMyMemoryStream.ActivateBuffer: Boolean;
begin
if mBufferSize = Zero then
Result:=false else begin
mBufferUsed:=mBufferSize;
Result:=true; end;
end;
  // Заполнение буффера нулями >
function TMyMemoryStream.ClearBuffer: Boolean;
begin
if Assigned(pBuffer) then
if mBufferSize = Zero then
Result:=false else try
FillChar(pBuffer^,mBufferSize,Zero);
mBufferUsed:=mBufferSize;
Result:=true; except
Result:=false; end else
Result:=false;
end;
  // Скопировать из буффера >
function TMyMemoryStream.CopyFromBuffer(pData: Pointer; Size: Cardinal): Boolean;
begin
if pData = nil then // Не действительный указатель >
Result:=false else
if mBufferSize = Zero then // Буффер пуст >
Result:=false else
if mBufferSize < Size then // Затребованные данные "вылазят" за пределы буффера >
Result:=false else begin
Move(pBuffer^,pData^,Size);
Result:=true; end;
end;
  // Скопировать в буффер >
function TMyMemoryStream.CopyToBuffer(pData: Pointer; Size: Cardinal): Boolean;
var p1:Pointer;
begin
if pData = nil then // Не действительный указатель >
Result:=false else
if Size = Zero then // Ничего не копировать >
Result:=false else
if mBufferSize = Zero then begin // Если у нас ещё нет памяти в буффере >
GetMem(pBuffer,Size);
mBufferSize:=Size;
Move(pData^,pBuffer^,Size);
mBufferUsed:=Size;
Result:=true; end else
if mBufferSize < Size then begin // Если не влазит в имеющийся буффер >
GetMem(p1,Size);
Move(pData^,p1^,Size);
FreeMem(pBuffer,mBufferSize);
pBuffer:=p1;
mBufferSize:=Size;
mBufferUsed:=Size;
Result:=true; end else begin // Если всё влазит >
Move(pData^,pBuffer^,Size);
mBufferUsed:=Size;
Result:=true; end;
end;
  // Уничтожыть буффер >
function TMyMemoryStream.DestroyBuffer: Boolean;
begin
if pBuffer = nil then
Result:=true else begin
FreeMem(pBuffer,mBufferSize);
mBufferSize:=Zero;
mBufferUsed:=Zero;
pBuffer:=nil;
Result:=true; end;
end;
  // Расширить на столько-то + сохранение уже имеющегося содержимого буффера >
function TMyMemoryStream.ExpandBufferFor(Size: Cardinal): Boolean;
var p1:Pointer;
begin
if Size = Zero then
Result:=true else
if mBufferSize = Zero then begin
GetMem(pBuffer,Size);
mBufferSize:=Size;
mBufferUsed:=Zero;
Result:=true; end else begin
GetMem(p1,mBufferSize+Size);
Move(pBuffer^,p1^,mBufferSize);
FreeMem(pBuffer,mBufferSize);
pBuffer:=p1;
mBufferSize:=mBufferSize+Size;
Result:=true; end;
end;
  // Расширить до стольки то + сохранение уже имеющегося содержимого буффера >
function TMyMemoryStream.ExpandBufferUntil(Size: Cardinal): Boolean;
var p1:Pointer;
begin
if Size = Zero then
Result:=true else
if mBufferSize = Zero then begin
GetMem(pBuffer,Size);
mBufferSize:=Size;
mBufferUsed:=Zero;
Result:=true; end else
if mBufferSize >= Size then
Result:=true else begin
GetMem(p1,mBufferSize+Size);
Move(pBuffer^,p1^,mBufferSize);
FreeMem(pBuffer,mBufferSize);
pBuffer:=p1;
mBufferSize:=mBufferSize+Size;
Result:=true; end;
end;
  // Интерпретировать содержимое как набор символов "строки" >
function TMyMemoryStream.GetBufferString: String;
var a1:Cardinal;
begin
if mBufferUsed = Zero then
Result:=EmptyString else begin
SetLength(Result,mBufferUsed);
for a1:=Zero to mBufferUsed-One do
Result[a1+One]:=Char(PBytePack(pBuffer)^[a1]); end;
end;
  // Просто перевыделение памяти >
function TMyMemoryStream.ReBuildBuffer(Size: Cardinal): Boolean;
begin
if mBufferSize = Size then
Result:=true else
if pBuffer = nil then begin
GetMem(pBuffer,Size);
mBufferSize:=Size;
mBUfferUsed:=Zero;
Result:=true; end else begin
FreeMem(pBuffer,mBufferSize);
GetMem(pBuffer,Size);
mBufferSize:=Size;
mBUfferUsed:=Zero;
Result:=true; end;
end;
  // Установка размеров буффера (c сохранением содержимого) >
function TMyMemoryStream.ResizeBuffer(Size: Cardinal): Boolean;
var p1:Pointer;
begin
if mBufferSize = Size then
Result:=true else
if pBuffer = nil then begin
GetMem(pBuffer,Size); // GlobalAlloc >
mBufferSize:=Size;
mBUfferUsed:=Zero;
Result:=true; end else begin
GetMem(p1,Size);
if mBufferSize > Size then
Move(pBuffer^,p1^,Size) else
Move(pBuffer^,p1^,mBufferSize);
FreeMem(pBuffer,mBufferSize);
pBuffer:=p1;
mBufferSize:=Size;
Result:=true; end;
end;
  // Наполнить буффер из этой строки >
procedure TMyMemoryStream.SetBufferString(Value: String);
var a1,a2:Cardinal;
begin
a2:=Length(Value);
if a2 > Zero then
if ExpandBufferUntil(a2) then begin
for a1:=One to a2 do
PBytePack(pBuffer)^[a1-One]:=Byte(Value[a1]);
mBufferUsed:=a2; end;
end;
  // Установить сколько использовано буффера в ручную >
procedure TMyMemoryStream.SetBufferUsed(Value: Cardinal);
begin
if Value > mBufferSize then
mBufferUsed:=mBufferSize else
mBufferUsed:=Value;
end;
  // Удалить\вырезать кусок из буффера >
function TMyMemoryStream.TakeFromBuffer(Size: Cardinal): Boolean;
begin
if Size = Zero then
Result:=false else
if mBufferSize < Size then
Result:=false else begin
if mBufferUsed-Size > Zero then begin
Move(Pointer(Cardinal(pBuffer)+Size)^,pBuffer^,mBufferUsed-Size);
mBufferUsed:=mBufferUsed-Size; end else
mBufferUsed:=Zero;
Result:=true; end;
end;
//=============================================================================>
//============================== TMyFileStream ================================>
//=============================================================================>
constructor TMyFileStream.Create;
var v1:TSystemInfo;
begin
inherited Create;
mHandle:=INVALID_HV;
mPath:=EmptyString;
pCrntPointer:=nil;
pBasePointer:=nil;
mMapping:=INVALID_HV;
GetSystemInfo(v1);
mSystemGranularity:=v1.dwAllocationGranularity;
end;
  // Деструктор >
destructor TMyFileStream.Destroy;
begin
CloseFull; // UnViewMap;
inherited Destroy;
end;
  // Открыть для чтения >
function TMyFileStream.OpenRead(Path: String): Boolean;
begin
if CloseFull then begin
if FileExists(Path) then
mHandle:=CreateFile(PChar(Path),GENERIC_READ,FILE_SHARE_READ,nil,OPEN_EXISTING,Zero,Zero) else
mHandle:=INVALID_HANDLE_VALUE;
Result:=Check;
if Result then
mPath:=Path; end else
Result:=false;
end;
  // Открыть для записи >
function TMyFileStream.OpenWrite(Path: String): Boolean;
begin
if CloseFull then begin
if FileExists(Path) then
mHandle:=CreateFile(PChar(Path),GENERIC_WRITE,FILE_SHARE_WRITE,nil,OPEN_EXISTING,Zero,Zero) else
mHandle:=CreateFile(PChar(Path),GENERIC_WRITE,FILE_SHARE_WRITE,nil,CREATE_ALWAYS,Zero,Zero);
Result:=Check;
if Result then
mPath:=Path; end else
Result:=false;
end;
  // Создавать новый\очищать старый >
function TMyFileStream.CreateWrite(Path: String): Boolean;
begin
if CloseFull then begin
mHandle:=CreateFile(PChar(Path),GENERIC_WRITE,FILE_SHARE_WRITE,nil,CREATE_ALWAYS,Zero,Zero);
Result:=Check;
if Result then
mPath:=Path; end else
Result:=false;
end;
  // Открыть для чтения и записи >
function TMyFileStream.OpenReadWrite(Path: String): Boolean;
begin
if CloseFull then begin
if FileExists(Path) then
mHandle:=CreateFile(PChar(Path),GENERIC_READ or GENERIC_WRITE,FILE_SHARE_READ or FILE_SHARE_WRITE,nil,OPEN_EXISTING,Zero,Zero) else
mHandle:=CreateFile(PChar(Path),GENERIC_READ or GENERIC_WRITE,FILE_SHARE_READ or FILE_SHARE_WRITE,nil,CREATE_ALWAYS,Zero,Zero);
Result:=Check;
if Result then
mPath:=Path; end else
Result:=false;
end;
  // Создание "объекта-отображения" >
function TMyFileStream.CreateMapping(cSize: Int64 = Zero): Boolean;
begin
if UnMap then begin
mMapping:=CreateFileMapping(mHandle,nil,PAGE_READWRITE,Cardinal(cSize shr _32),Cardinal(cSize),nil);
Result:=mMapping <> INVALID_HV; end else
Result:=false;
end;
  // Картирование "объекта-отображения" в память процесса >
function TMyFileStream.CreateView(cPosition,cCount: Int64): Boolean;
var v1:Int64;
begin
if UnView then begin
v1:=(cPosition div mSystemGranularity)*mSystemGranularity;
pBasePointer:=MapViewOfFile(mMapping,FILE_MAP_ALL_ACCESS,Cardinal(v1 shr _32),Cardinal(v1),Cardinal(cCount)+Cardinal(cPosition-v1));
if pBasePointer = nil then
Result:=false else begin
pCrntPointer:=Pointer(Cardinal(pBasePointer)+Cardinal(cPosition-v1));
Result:=true; end; end else
Result:=false;
end;
  // Создать объект отображения и отобразить его в память программы >
function TMyFileStream.MapView(cPosition,cCount: Int64): Boolean;
var v1:Int64;
begin
if pBasePointer <> nil then
if not UnMapViewOfFile(pBasePointer) then begin
Result:=false;
Exit; end;
if mMapping <> INVALID_HV then
if not CloseHandle(mMapping) then begin
Result:=false;
Exit; end;
mMapping:=CreateFileMapping(mHandle,nil,PAGE_READWRITE,Zero,Zero,nil);
if mMapping = INVALID_HV then begin
Result:=false;
Exit; end;
v1:=(cPosition div mSystemGranularity)*mSystemGranularity;
pBasePointer:=MapViewOfFile(mMapping,FILE_MAP_ALL_ACCESS,Cardinal(v1 shr _32),Cardinal(v1),Cardinal(cCount)+Cardinal(cPosition-v1));
if pBasePointer = nil then begin
Result:=false;
Exit; end;
pCrntPointer:=Pointer(Cardinal(pBasePointer)+Cardinal(cPosition-v1));
Result:=true; 
end;
  // Уничтожение "объекта-отображения" >
function TMyFileStream.UnMap: Boolean;
begin
if mMapping = INVALID_HV then
Result:=true else
if CloseHandle(mMapping) then begin
mMapping:=INVALID_HV;
Result:=true; end else
Result:=false
end;
  // Прекращение картирования "объекта-отображения" >
function TMyFileStream.UnView: Boolean;
begin
if pBasePointer = nil then
Result:=true else
if UnMapViewOfFile(pBasePointer) then begin
pBasePointer:=nil;
pCrntPointer:=nil;
Result:=true; end else
Result:=false;
end;
  // "РазОтобразить" объект + удалить его >
function TMyFileStream.UnViewMap: Boolean;
begin
if pBasePointer <> nil then
if UnMapViewOfFile(pBasePointer) then begin
pBasePointer:=nil;
pCrntPointer:=nil; end else begin
Result:=false;
Exit; end;
if mMapping = INVALID_HV then
Result:=true else
if CloseHandle(mMapping) then begin
mMapping:=INVALID_HV;
Result:=true; end else
Result:=false;
end;
  // Закрыть файл >
function TMyFileStream.Close: Boolean;
begin
if mHandle = INVALID_HV then
Result:=true else
if CloseHandle(mHandle) then begin
mHandle:=INVALID_HV;
Result:=true; end else
Result:=false;
end;
  // Разорвать все связи с файлом >
function TMyFileStream.CloseFull: Boolean;
begin
if UnViewMap then
Result:=Close else
Result:=false;
end;
  // Разорвать все связи с файлом и удалить его >
function TMyFileStream.Delete: Boolean;
begin
if Check then
if CloseFull then
Result:=DeleteFile(PChar(mPath)) else
Result:=false else
Result:=false;
end;
  // Копировать по указанному адресу >
function TMyFileStream.Copy(Value: String; OverWrite: Boolean = false): Boolean;
begin
Result:=CopyFile(PChar(mPath),PChar(Value),not OverWrite);
end;
  // Проверка валидности дескриптора файла >
function TMyFileStream.Check: Boolean;
begin
Result:=mHandle <> INVALID_HV;
end;
  // Узнать о достижении конца файла >
function TMyFileStream.EndOfFile: Boolean;
begin
Result:=GetFileSize(mHandle,nil) > SetFilePointer(mHandle,Zero,nil,FILE_CURRENT);
end;
  // Установить конец файла в текущую позицию >
function TMyFileStream.SetEndHere: Boolean;
begin
Result:=SetEndOfFile(mHandle);
end;
  // Узнать 64-битное положение в файле >
function TMyFileStream.GetPos: Int64;
var a1,a2:Cardinal;
begin
a1:=Zero;
a2:=SetFilePointer(mHandle,Zero,@a1,FILE_CURRENT);
Result:=a2 or a1 shl _32;
end;
  // "64-битное" положение в файле >
procedure TMyFileStream.SetPos(Value: Int64);
var a1:Cardinal;
begin
a1:=Value shr _32;
SetFilePointer(mHandle,Cardinal(Value),@a1,FILE_BEGIN);
end;
  // 64-битный размер файла >
function TMyFileStream.GetSize: Int64;
var a1,a2:Cardinal;
begin
a2:=GetFileSize(mHandle,@a1);
Result:=a2 or a1 shl _32;
end;
  // Установить размеры файла >
procedure TMyFileStream.SetSize(Value: Int64);
var a1:Cardinal;
begin
a1:=Value shr _32;
SetFilePointer(mHandle,Cardinal(Value),@a1,FILE_BEGIN);
SetEndOfFile(mHandle);
end;
  // Сдвинуть позицию чтения\записи в начало файла >
function TMyFileStream.GoToBegin: Boolean;
begin
SetFilePointer(mHandle,Zero,nil,FILE_BEGIN);
Result:=true;
end;
  // Сдвинуть позицию чтения\записи в конец файла >
function TMyFileStream.GoToEnd: Boolean;
begin
SetFilePointer(mHandle,Zero,nil,FILE_END);
Result:=true;
end;
  // Возвращает адрес файла в PChar-виде >
function TMyFileStream.GetPCharFilePath: PChar;
begin
Result:=PChar(mPath);
end;
  // Сравнить с другим файлом на такую длинну >
function TMyFileStream.SimilarTo(Value: TMyFileStream; cLength: Cardinal = mnKB): Cardinal;
var a1,a2,a3:Cardinal; b1,b2:Byte;
begin
if Value = nil then
Result:=mError else
if Value = Self then
Result:=mTrue else
if not Check then
Result:=mError else
if not Value.Check then
Result:=mError else
if mPath = Value.mPath then
Result:=mTrue else begin
a3:=Value.Size;
if a3 <> Size then
Result:=mFalse else begin
Result:=mTrue;
if cLength = Zero then
a2:=a3 else
if cLength > a3 then
a2:=a3 else
a2:=cLength;
for a1:=One to a2 do
if not Read(b1) then begin
Result:=mError;
Break; end else
if not Value.Read(b2) then begin
Result:=mError;
Break; end else
if b1 <> b2 then begin
Result:=mFalse;
Break; end; end; end;
end;
  // Прочитать в указатель >
function TMyFileStream.Read(var pData: Pointer; Size: Cardinal): Boolean;
var a1:Cardinal;
begin
if ReadFile(mHandle,pData^,Size,a1,nil) then
Result:=a1 = Size else
Result:=false;
end;
  // Прочитать... >
function TMyFileStream.Read(var Value; Size: Cardinal): Boolean;
var a1:Cardinal;
begin
if ReadFile(mHandle,Value,Size,a1,nil) then
Result:=a1 = Size else
Result:=false;
end;
  // Прочитать в буффер >
function TMyFileStream.Read: Boolean;
begin
if pBuffer = nil then
Result:=false else
if ReadFile(mHandle,pBuffer^,mBufferSize,mBufferUsed,nil) then
Result:=mBufferUsed = mBufferSize else
Result:=false;
end;
  // Прочитать весь файлв буффер >
function TMyFileStream.ReadAll: Boolean;
begin
ReBuildBuffer(GetSize);
if ReadFile(mHandle,pBuffer^,mBufferSize,mBufferUsed,nil) then
Result:=mBufferUsed = mBufferSize else
Result:=false;
end;
  // Прочитать весь файлв буффер >
function TMyFileStream.ReadAdd(Size: Cardinal): Boolean;
var a1:Cardinal;
begin
if Size = Zero then
Result:=true else
if ExpandBufferUntil(mBufferUsed+Size) then
if ReadFile(mHandle,Pointer(Cardinal(pBuffer)+mBufferSize-Size)^,Size,a1,nil) then begin
mBufferUsed:=mBufferUsed+a1;
Result:=Size = a1; end else
Result:=false else
Result:=false;
end;
  // Прочитать что-то начиная от такой-то позиции >
function TMyFileStream.Read(var Value; nSize: Cardinal; nPosition: Int64): Boolean;
var a1,a2:Cardinal; a3:Int64;
begin
a1:=nPosition shr _32;
a2:=SetFilePointer(mHandle,Cardinal(nPosition),@a1,FILE_BEGIN);
a3:=a2 or a1 shl _32;
if a3 = nPosition then
if ReadFile(mHandle,Value,nSize,a1,nil) then
Result:=nSize = a1 else
Result:=false else
Result:=false;
end;
  // Записать что-то с такой-то позиции >
function TMyFileStream.Write(var Value; nSize: Cardinal; nPosition: Int64): Boolean;
var a1,a2:Cardinal; a3:Int64;
begin
a1:=nPosition shr _32;
a2:=SetFilePointer(mHandle,Cardinal(nPosition),@a1,FILE_BEGIN);
a3:=a2 or a1 shl _32;
if a3 = nPosition then
if WriteFile(mHandle,Value,nSize,a1,nil) then
Result:=nSize = a1 else
Result:=false else
Result:=false;
end;
  // Записать из указателя >
function TMyFileStream.Write(pData: Pointer; Size: Cardinal): Boolean;
var a1:Cardinal;
begin
if WriteFile(mHandle,pData^,Size,a1,nil) then
Result:=a1 = Size else
Result:=false;
end;
  // Записать из буффера >
function TMyFileStream.Write(var Value; Size: Cardinal): Boolean;
var a1:Cardinal;
begin
if WriteFile(mHandle,Value,Size,a1,nil) then
Result:=a1 = Size else
Result:=false;
end;
  // Записать из буффера >
function TMyFileStream.Write: Boolean;
begin
if pBuffer = nil then
Result:=false else
if WriteFile(mHandle,pBuffer^,mBufferSize,mBufferUsed,nil) then
Result:=mBufferUsed = mBufferSize else
Result:=false;
end;
  // Прочитать в нультерминальную строку >
function TMyFileStream.Read(var pData: PChar): Boolean;
var a1,a2:Cardinal;
begin
if ReadFile(mHandle,a1,cCardinalSize,a2,nil) then
if a2 = cCardinalSize then
if a1 = Zero then begin
pData:=nil;
Result:=true; end else begin
if Assigned(pData) then begin
a2:=Zero;
while PBytePack(pData)^[a2] <> Zero do
Inc(a2);
FreeMem(pData,a2+One); end;
GetMem(pData,a1+One);
PBytePack(pData)^[a1]:=Zero;
if ReadFile(mHandle,pData,a1,a2,nil) then
Result:=a2 = a1 else
Result:=false; end else
Result:=false else
Result:=false;
end;
  // Записать нультерминальную строку >
function TMyFileStream.Write(var pData: PChar): Boolean;
var a1,a2:Cardinal;
begin
a1:=Zero;
if Assigned(pData) then
while PBytePack(pData)^[a1] <> Zero do
Inc(a1);
if WriteFile(mHandle,a1,cCardinalSize,a2,nil) then
if a2 = cCardinalSize then
if a1 = Zero then
Result:=true else
if WriteFile(mHandle,pData^,a1,a2,nil) then
Result:=a1 = a2 else
Result:=false else
Result:=false else
Result:=false;
end;
  // Читаем слово >
function TMyFileStream.Read(var Value: Word): Boolean;
var a1:Cardinal;
begin
if ReadFile(mHandle,Value,cWordSize,a1,nil) then
Result:=a1 = cWordSize else
Result:=false;
end;
  // Читаем байт >
function TMyFileStream.Read(var Value: Byte): Boolean;
var a1:Cardinal;
begin
if ReadFile(mHandle,Value,cByteSize,a1,nil) then
Result:=a1 = cByteSize else
Result:=false;
end;
  // Читаем действительное >
function TMyFileStream.Read(var Value: Cardinal): Boolean;
var a1:Cardinal;
begin
if ReadFile(mHandle,Value,cCardinalSize,a1,nil) then
Result:=a1 = cCardinalSize else
Result:=false;
end;
  // Читаем действительное >
function TMyFileStream.ReadCardinal: Cardinal;
var a1:Cardinal;
begin
ReadFile(mHandle,Result,cCardinalSize,a1,nil);
end;
  // Пишем действительное >
function TMyFileStream.WriteCardinal(Value: Cardinal): Boolean;
var a1:Cardinal;
begin
if WriteFile(mHandle,Value,cCardinalSize,a1,nil) then
Result:=cCardinalSize = a1 else
Result:=false;
end;
  // Читаем целое >
function TMyFileStream.Read(var Value: Integer): Boolean;
var a1:Cardinal;
begin
if ReadFile(mHandle,Value,cIntegerSize,a1,nil) then
Result:=a1 = cIntegerSize else
Result:=false;
end;
  // Пишем слово >
function TMyFileStream.Write(var Value: Word): Boolean;
var a1:Cardinal;
begin
if WriteFile(mHandle,Value,cWordSize,a1,nil) then
Result:=a1 = cWordSize else
Result:=false;
end;
  // Пишем байт >
function TMyFileStream.Write(var Value: Byte): Boolean;
var a1:Cardinal;
begin
if WriteFile(mHandle,Value,cByteSize,a1,nil) then
Result:=a1 = cByteSize else
Result:=false;
end;
  // Пишем действительное >
function TMyFileStream.Write(var Value: Cardinal): Boolean;
var a1:Cardinal;
begin
if WriteFile(mHandle,Value,cCardinalSize,a1,nil) then
Result:=a1 = cCardinalSize else
Result:=false;
end;
  // Пишем целое >
function TMyFileStream.Write(var Value: Integer): Boolean;
var a1:Cardinal;
begin
if WriteFile(mHandle,Value,cIntegerSize,a1,nil) then
Result:=a1 = cIntegerSize else
Result:=false;
end;
  // Прочитать "нормальную" строку >
function TMyFileStream.Read(var Value: String): Boolean;
var a1,a2:Cardinal;
begin
if ReadFile(mHandle,a1,cCardinalSize,a2,nil) then
if a2 = cCardinalSize then
if a1 = Zero then begin
Value:=EmptyString;
Result:=true; end else begin
ResizeBuffer(a1);
if ReadFile(mHandle,pBuffer^,mBufferSize,mBufferUsed,nil) then
if mBufferSize = mBufferUsed then begin
SetLength(Value,a1);
for a2:=One to a1 do
Value[a2]:=Char(PBytePack(pBuffer)^[a2-One]);
Result:=true; end else
Result:=false else
Result:=false; end else
Result:=false else
Result:=false;
end;
  // Возвращает результатом прочитанную строчку >
function TMyFileStream.ReadString: String;
var a1,a2:Cardinal;
begin
if ReadFile(mHandle,a1,cCardinalSize,a2,nil) then
if a2 = cCardinalSize then
if a1 = Zero then
Result:=EmptyString else begin
ResizeBuffer(a1);
if ReadFile(mHandle,pBuffer^,mBufferSize,mBufferUsed,nil) then
if mBufferSize = mBufferUsed then begin
SetLength(Result,a1);
for a2:=One to a1 do
Result[a2]:=Char(PBytePack(pBuffer)^[a2-One]); end else
Result:=EmptyString else
Result:=EmptyString; end else
Result:=EmptyString else
Result:=EmptyString;
end;
  // Записать "обычную" строку >
function TMyFileStream.Write(const Value: String): Boolean;
var a1,a2:Cardinal;
begin
a1:=Length(Value);
if WriteFile(mHandle,a1,cCardinalSize,a2,nil) then
if a2 = cCardinalSize then
if a1 = Zero then
Result:=true else begin
ResizeBuffer(a1);
for a2:=One to a1 do
PBytePack(pBuffer)^[a2-One]:=Byte(Value[a2]);
if WriteFile(mHandle,pBuffer^,mBufferSize,mBufferUsed,nil) then
Result:=mBufferSize = mBufferUsed else
Result:=false; end else
Result:=false else
Result:=false;
end;
  // Читаем большое целое >
function TMyFileStream.Read(var Value: Int64): Boolean;
var a1:Cardinal;
begin
if ReadFile(mHandle,Value,cInt64Size,a1,nil) then
Result:=a1 = cInt64Size else
Result:=false;
end;
  // Читаем вещественное число >
function TMyFileStream.Read(var Value: Single): Boolean;
var a1:Cardinal;
begin
if ReadFile(mHandle,Value,cSingleSize,a1,nil) then
Result:=a1 = cSingleSize else
Result:=false;
end;
  // Читаем булево значение >
function TMyFileStream.Read(var Value: Boolean): Boolean;
var a1:Cardinal; b1:Byte;
begin
if ReadFile(mHandle,b1,cByteSize,a1,nil) then
Result:=a1 = cByteSize else
Result:=false;
if b1 = Zero then
Value:=false else
Value:=true;
end;
  // Пишем большое целое >
function TMyFileStream.Write(var Value: Int64): Boolean;
var a1:Cardinal;
begin
if WriteFile(mHandle,Value,cInt64Size,a1,nil) then
Result:=a1 = cInt64Size else
Result:=false;
end;
  // Пишем вещественное число >
function TMyFileStream.Write(var Value: Single): Boolean;
var a1:Cardinal;
begin
if WriteFile(mHandle,Value,cSingleSize,a1,nil) then
Result:=a1 = cSingleSize else
Result:=false;
end;
  // Пишем булево значение >
function TMyFileStream.Write(var Value: Boolean): Boolean;
var a1:Cardinal; b1:Byte;
begin
if Value then
b1:=One else
b1:=Zero;
if WriteFile(mHandle,b1,cByteSize,a1,nil) then
Result:=a1 = cByteSize else
Result:=false;
end;
  // Прочитать строчку (текстовый формат файла) >
function TMyFileStream.ReadLn(var Value: String): Boolean;
var b1,b2:Byte; a1,a2:Cardinal;
begin
Result:=true; // Обязательно нужно что-то с этим сделать 8-/ >
Value:=EmptyString;
while true do
if ReadFile(mHandle,b1,cByteSize,a1,nil) and (a1 = cByteSize) then
if b1 = mEndLine then
if ReadFile(mHandle,b2,cByteSize,a2,nil) and (a2 = cByteSize) then
if b2 = mnBreakLine then begin
Result:=true;
Break; end else
Value:=Value+Char(b1)+Char(b2) else begin
Value:=Value+Char(b1);
Result:=true;
Break; end else
Value:=Value+Char(b1) else begin
Result:=false;
Break; end;
if Length(Value) > Zero then
Result:=true;
end;
  // Прочитать строчку (текстовый формат файла) в "PMyString" >
function TMyFileStream.ReadLn(var pData: PMyString): Boolean;
var b1,b2:Byte; a1,a2:Cardinal; p1:PBytePack;
begin // Начало всех этих... ЧТУЩЕКЪ... >
a1:=Zero;
a2:=Zero;
p1:=MyStringGetPBytePack(pData);
pData^.mUsedSize:=Zero;
while true do
if ReadFile(mHandle,b1,cByteSize,a1,nil) and (a1 = cByteSize) then
if b1 = mEndLine then
if ReadFile(mHandle,b2,cByteSize,a2,nil) and (a2 = cByteSize) then
if b2 = mnBreakLine then
Break else begin 
p1[pData^.mUsedSize]:=b1;
p1[pData^.mUsedSize+One]:=b2;
Inc(pData^.mUsedSize,Two);
if pData^.mSize < (pData^.mUsedSize+Ten) then begin // Проверка размеров строки >
MyStringSetSize(pData,pData^.mSize*Two);
p1:=MyStringGetPBytePack(pData); end; end else begin
p1[pData^.mUsedSize]:=b1;
Inc(pData^.mUsedSize);
Break; end else begin
p1[pData^.mUsedSize]:=b1;
Inc(pData^.mUsedSize);
if pData^.mSize = pData^.mUsedSize then begin // Проверка размеров строки >
MyStringSetSize(pData,pData^.mSize*Two);
p1:=MyStringGetPBytePack(pData); end; end else
Break;
Result:=(a1+a2)>Zero;
end;
  // Записать строчку (текстовый формат файла) >
function TMyFileStream.WriteLn(const Value: String): Boolean;
var a1,a2,a3:Cardinal;
begin
a2:=Length(Value);
a3:=a2+Two;
if mBufferSize < a3 then
ResizeBuffer(a3);
for a1:=One to a2 do
PBytePack(pBuffer)^[a1-One]:=Byte(Value[a1]);
PBytePack(pBuffer)^[a2]:=mEndLine;
PBytePack(pBuffer)^[a2+One]:=mnBreakLine;
if WriteFile(mHandle,pBuffer^,a3,a1,nil) then
Result:=a1 = a3 else
Result:=false;
end;
  // Прочитать\создать "мою строку" >
function TMyFileStream.Read(var pData: PMyString): Boolean;
var a1:Cardinal; v1:TMyString;
begin
if ReadFile(mHandle,v1,cMyStringSize,a1,nil) and (a1 = cMyStringSize) then begin
GetMem(Pointer(pData),v1.mSize+cMyStringSize);
pData^:=v1;
if v1.mUsedSize > Zero then
if ReadFile(mHandle,Pointer(Cardinal(pData)+cMyStringSize)^,v1.mUsedSize,a1,nil) then
Result:=a1 = v1.mUsedSize else
Result:=false else
Result:=true; end else begin
pData:=nil;
Result:=false; end;
end;
  // Записать из "моей строки" >
function TMyFileStream.Write(const pData: PMyString): Boolean;
var a1,a2:Cardinal;
begin
if pData = nil then
Result:=false else begin
a2:=pData^.mUsedSize+cMyStringSize;
if WriteFile(mHandle,pData^,a2,a1,nil) then
Result:=a1 = a2 else
Result:=false; end;
end;
//=============================================================================>
//============================== TMyWAVStream =================================>
//=============================================================================>
constructor TMyWAVStream.Create;
begin
inherited Create;
pWAVHeader:=@mWAVHeader;
ReBuildBuffer(cUsualAudioBufferSize); // "Стандартный" размер буффера для хранения звука >
end;
  // Деструктор >
destructor TMyWAVStream.Destroy;
begin
inherited Destroy;
end;
  // Проверка ликвидности + проверка заголовка >
function TMyWAVStream.Check: Boolean;
begin
if inherited Check then
with mWAVHeader do begin
if UpperCase(ChunkID) = mRIFF then
if ChunkSize = Size-Eight then
if UpperCase(Format) = mR_WAV then
Result:=AudioFormat = One else
Result:=false else
Result:=false else
Result:=false;
if Result and (Size > cWAVHeaderSize) then
if SubChunk2Size < (Size - cWAVHeaderSize) then
SubChunk2Size:=Size - cWAVHeaderSize;
end else
Result:=false;
end;
  // Копировать заголовок >
procedure TMyWAVStream.SetHeader(pData: PMyWAVHeader);
begin
if pData <> nil then
if pData <> pWAVHeader then
mWAVHeader:=pData^;
end;
  // Записать заголовок >
function TMyWAVStream.WriteHeader: Boolean;
begin
with mWAVHeader do begin
ChunkID:=mRIFF;
ChunkSize:=Size-Eight;
Format:=mR_WAV;
SubChunk1ID:=mR_SC1ID;
SubChunk1Size:=_16;
AudioFormat:=One;
ByteRate:=SampleRate*NumChannels*BitsPerSample div Eight;
BlockAlign:=NumChannels*BitsPerSample div Eight;
SubChunk2ID:=mR_DATA;
SubChunk2Size:=Size-cWAVHeaderSize; end;
Result:=Write(mWAVHeader,cWAVHeaderSize);
end;
  // Запись данных в WAV-файл >
function TMyWAVStream.WriteWAVData(pData: Pointer; Size: Cardinal): Boolean;
begin
if pData = nil then
Result:=false else
if Size = Zero then
Result:=false else
if Write(pData^,Size) then begin
GoToBegin;
Result:=WriteHeader;
GoToEnd; end else
Result:=false;
end;
  // Открыть для чтения >
function TMyWAVStream.OpenRead(Path: String): Boolean;
begin
if inherited OpenRead(Path) then
if Read(mWAVHeader,cWAVHeaderSize) then
if Check then
Result:=ReBuildBuffer(cUsualAudioBufferSize) else
Result:=false else
Result:=false else
Result:=false;
end;
  // Прочитать весь "звук" из файла в буффер >
function TMyWAVStream.ReadAll: Boolean;
begin
ReBuildBuffer(mWAVHeader.SubChunk2Size);
Result:=Read;
end;
  // Открыть для записи >
function TMyWAVStream.OpenWrite(Path: String): Boolean;
begin
if inherited OpenWrite(Path) then begin
WriteHeader;
Result:=Check end else
Result:=false;
end;
//=============================================================================>
//=================================== TMyLog ==================================>
//=============================================================================>
constructor TMyLog.Create(Value: TMyFileTrash; cName: String);
begin // Конструктор >
inherited Create;
if Value = nil then
mFileName:=cName else
mFileName:=Value.FilePath(cName);
end;
  // Деструктор >
destructor TMyLog.Destroy;
begin
inherited Destroy;
end;
  // Очистить файл >
procedure TMyLog.ClearLog;
begin
CreateWrite(PChar(mFileName));
Close;
end;
  // Пустую строчку >
procedure TMyLog.WriteLog;
begin
WriteLog(EmptyString);
end;
  // Записать свою строчку >
procedure TMyLog.WriteLog(Value: String);
var p1:PMyTime; s1:String;
begin // Вот, через неё и будем записывать, все перегрузки 8-) >
if OpenWrite(PChar(mFileName)) then begin 
GoToEnd;
UpDatePMyTime(p1);
with p1^ do
s1:=IntToStr(bHour)+mnTwoDots+IntToStr(bMinute)+mnTwoDots+IntToStr(bSecond)+mDivOfCom+Value;
WriteLn(s1);
Dispose(p1);
Close; end;
end;
  // Записать строчку из списка >
procedure TMyLog.WriteLog(Index: Cardinal);
begin
WriteLog(Line[Index]);
end;
  // Записать строчку и цифру >
procedure TMyLog.WriteLog(Index,Value: Cardinal);
begin
WriteLog(Line[Index]+mDivOfCom+IntToStr(Value));
end;
  // Совместить >
procedure TMyLog.WriteLog(Index: Cardinal; AdditionalValue: String);
begin
if Count > Index then
WriteLog(Line[Index]+mDivOfCom+AdditionalValue) else
WriteLog(AdditionalValue);
end;
  // Совместить "индексная строка"+"булево значение" >
procedure TMyLog.WriteLog(Index: Cardinal; Result: Boolean);
begin
if Result then
WriteLog(Line[Index]+mDivOfCom+Line[mnl_YES]) else
WriteLog(Line[Index]+mDivOfCom+Line[mnl_NO]);
end;
  // Совместить "индексная строка"+"индексная строка"+"текстовое значение" >
procedure TMyLog.WriteLog(Index1,Index2: Cardinal; AdditionalValue: String);
begin
WriteLog(Line[Index1]+mDivOfCom+Line[Index2]+mDivOfCom+AdditionalValue);
end;
  // Совместить "индексная строка"+"дополнительная строка"+"булево значение" >
procedure TMyLog.WriteLog(Index: Cardinal; AdditionalValue: String; Result: Boolean);
begin
if Result then
WriteLog(Line[Index]+mDivOfCom+Line[mnl_YES]+mDivOfCom+AdditionalValue) else
WriteLog(Line[Index]+mDivOfCom+Line[mnl_NO]+mDivOfCom+AdditionalValue);
end;
  // Записать коментарии плюс "цифру" >
procedure TMyLog.WriteLog(Coment: String; Value: Integer);
begin
WriteLog(Coment+mDivOfCom+IntToStr(Value));
end;
//=============================================================================>
//================================= TMyFileTrash ==============================>
//=============================================================================>
constructor TMyFileTrash.Create(sTrashName: String; Value :TMyApplication);
begin // Конструктор >
inherited Create;
mApplication:=Value;
mTrashName:=sTrashName;
PathInit;
end;
  // Деструктор >
destructor TMyFileTrash.Destroy;
begin
inherited Destroy;
end;
  // Подготовка всех "постоянных" путей, запоминает полный путь к папке="копилке", и если её нет, то пытается создать >
procedure TMyFileTrash.PathInit;
begin
mExePath:=ExtractFilePath(GetExeName);
mTrashPath:=mExePath+mTrashName;
if not FileExists(mTrashPath) then
if not CreateDirectory(Pchar(mTrashPath),nil) then
mTrashPath:=EmptyString;
if mTrashPath <> EmptyString then
mTrashPath:=mTrashPath+mnSlash;
end;
  // Есть ли такой файл (только имя и расширение, без полного пути) >
function TMyFileTrash.FileExisto(sName: String): Boolean;
var a1,a2:Cardinal;
begin
a2:=Length(sName);
if a2 = Zero then
Result:=false else begin
a1:=Pos(mnDot,sName);
if a1 = Zero then
Result:=false else
if a1 = One then
Result:=false else
if a1 = a2 then
Result:=false else
Result:=FileExists(mTrashPath+ExtractFileExt(sName)+mnSlash+sName); end;
end;
  // Превращает имя в полный путь сквозь папку "mnTrashDir" >
function TMyFileTrash.FilePath(sName: String): String;
var a1,a2:Cardinal;
begin
a2:=Length(sName);
if a2 = Zero then
Result:=EmptyString else begin
a1:=Pos(mnDot,sName);
if a1 = Zero then
Result:=EmptyString else
if a1 = One then
Result:=EmptyString else
if a1 = a2 then
Result:=EmptyString else
Result:=mTrashPath+ExtractFileExt(sName)+mnSlash+sName; end;
end;
  // Превращает имя в полный путь сквозь папку "mnTrashDir" >
function TMyFileTrash.FilePPath(sName: String): PChar;
var a1,a2:Cardinal;
begin
a2:=Length(sName);
if a2 = Zero then
Result:=nil else begin
a1:=Pos(mnDot,sName);
if a1 = Zero then
Result:=nil else
if a1 = One then
Result:=nil else
if a1 = a2 then
Result:=nil else
Result:=PChar(mTrashPath+ExtractFileExt(sName)+mnSlash+sName); end;
end;
  // Создать "в мусорке" папку по укзанному расширению >
function TMyFileTrash.AddExtension(const Value: String): Boolean;
begin
if FileExists(mTrashPath+Value) then
Result:=true else
Result:=CreateDirectory(Pchar(mTrashPath+Value),nil);
end;
  // Скопировать в папку "mTrashName" >
function TMyFileTrash.FileCopyIn(const Path: String; ReMoveEx: Boolean = false; OverWrite: Boolean = false): Boolean;
var a1,a2:Cardinal; s1,s2,s3:string;
begin
if FileExists(Path) then begin // Такой файл вообще есть? >
if Pos(mnSlash,Path) > Zero then // Это полный путь, или "по месту" ? >
s1:=ExtractFileName(Path) else
s1:=Path;
a2:=Length(s1);
a1:=Pos(mnDot,s1);
if a1 = Zero then
Result:=false else
if a1 = One then
Result:=false else
if a1 = a2 then
Result:=false else begin
s2:=UpperCase(ExtractFileExt(s1)); // Только расширение >
s3:=mTrashPath+s2; // Адрес папки по расширеню >
s1:=s3+mnSlash+s1; // Полный адрес в "папке" >
if not FileExists(s3) then
if not CreateDirectory(Pchar(s3),nil) then
Result:=false else
if FileExists(s1) then
if OverWrite then
Result:=CopyFile(PChar(Path),PChar(s1),false) else
Result:=true else
Result:=CopyFile(PChar(Path),PChar(s1),OverWrite) else
if FileExists(s1) then
if OverWrite then
Result:=CopyFile(PChar(Path),PChar(s1),false) else
Result:=true else
Result:=CopyFile(PChar(Path),PChar(s1),OverWrite);
if Result and ReMoveEx then
Result:=DeleteFile(PChar(Path)); end; end else begin
s1:=UpperCase(ExtractFileExt(Path)); // Только расширение >
if Length(s1) = Zero then
Result:=false else begin
s2:=mTrashPath+s1;
if FileExists(s2) then
Result:=true else
Result:=CreateDirectory(Pchar(s2),nil); end; end; // Адрес папки по расширению >
end;
  // "Затягивание" файлов (перемещение) в "мусорку/копилку" Х-) >
function TMyFileTrash.FileMoveIn(const Path: String): Boolean;
var a1,a2:Cardinal; a3:Integer; s1,s2,s3,s4,s5:string; f1:TMyFileStream;
begin
a2:=Length(Path);
if a2 = Zero then
Result:=false else
if FileExists(Path) then begin // Такой файл вообще есть? >
if Pos(mnSlash,Path) > Zero then // Это полный путь, или "по месту" ? >
s1:=ExtractFileName(Path) else
s1:=Path;
a1:=Pos(mnDot,s1); // Узнаём положение точки, чтобы проверить строку адреса на наличие расширение >
if a1 = Zero then // Нет точки >
Result:=false else // Выходим - не правильный адрес - результат = нет >
if a1 = One then // Нет имени - сразу идёт точка >
Result:=false else // Выходим - не правильный адрес - результат = нет >
if a1 = a2 then // Нет расширения - точка последний знак в строке >
Result:=false else begin // Выходим - не правильный адрес - результат = нет >
s2:=UpperCase(ExtractFileExt(s1)); // Только расширение >
s3:=mTrashPath+s2; // Адрес папки по расширеню >
s1:=s3+mnSlash+s1; // Полный адрес в "папке" >
if FileExists(s3) then // Проверка существования папки для такого расширения >
if FileExists(s1) then begin // -=> Стаким именем файл в папке уже есть -=>
s4:=s3+mnSlash+ExtractFileNameOnly(Path);
s5:=mnDot+s2;
f1:=TMyFileStream.Create;
if not OpenRead(PChar(Path)) then
Result:=false else
if not f1.OpenRead(PChar(s1)) then
Result:=false else
if SimilarTo(f1,Zero) = mTrue then
Result:=true else begin
a3:=Zero;
while FileExists(s4+IntToStr(a3)+s5) do begin
if f1.OpenRead(PChar(s4+IntToStr(a3)+s5)) then
if SimilarTo(f1,Zero) = mTrue then begin
a3:=mOne;
Break; end else
Inc(a3); end;
if a3 = mOne then
Result:=true else
if CloseFull then
Result:=MoveFile(PChar(Path),PChar(s4+IntToStr(a3)+s5)) else
Result:=false; end;
f1.Destroy; end else // <=- Стаким именем файл в папке уже есть <=-
Result:=MoveFile(PChar(Path),PChar(s1)) else // Файла нету - 8) >
if CreateDirectory(Pchar(s3),nil) then // папки такой (по расширению) нету >
Result:=MoveFile(PChar(Path),PChar(s1)) else
Result:=false; end; end else
Result:=false;
end;
  // Переместить файлы из указанной папки >
procedure TMyFileTrash.FilesMoveIn(const Path: String);
var a1:Cardinal; v3:TWin32FindData;
begin
a1:=FindFirstFile(PChar(SlashSep(Path,mnSearchMask)),v3);
if a1 <> INVALID_HANDLE_VALUE then begin
if String(v3.cFileName) <> mnDirIn then
if String(v3.cFileName) <> mnDirNameUp then
if (v3.dwFileAttributes and FILE_ATTRIBUTE_DIRECTORY) > Zero then
FilesMoveIn(SlashSep(Path,v3.cFileName)) else
FileMoveIn(SlashSep(Path,v3.cFileName));
while FindNextFile(a1,v3) do
if String(v3.cFileName) <> mnDirIn then
if String(v3.cFileName) <> mnDirNameUp then
if (v3.dwFileAttributes and FILE_ATTRIBUTE_DIRECTORY) > Zero then
FilesMoveIn(SlashSep(Path,v3.cFileName)) else
FileMoveIn(SlashSep(Path,v3.cFileName));
FindClose(a1); end;
end;
  // Скопировать файлы из указанного адреса >
procedure TMyFileTrash.FilesCopyIn(const Path: String);
var a1,a2,a3:Cardinal; s1,s2,s3:string; v3:TWin32FindData;
begin
a3:=FindFirstFile(PChar(SlashSep(Path,mnSearchMask)),v3);
if a3 <> INVALID_HANDLE_VALUE then begin
if String(v3.cFileName) <> mnDirIn then
if String(v3.cFileName) <> mnDirNameUp then
if (v3.dwFileAttributes and FILE_ATTRIBUTE_DIRECTORY) > Zero then
FilesCopyIn(SlashSep(Path,v3.cFileName)) else begin
s1:=v3.cFileName;
a2:=Length(s1);
a1:=Pos(mnDot,s1);
if (a1 > One) and (a1 < a2) then begin
s2:=UpperCase(ExtractFileExt(s1)); // Только расширение >
s3:=mTrashPath+s2; // Адрес папки по расширеню >
s1:=s3+mnSlash+s1; // Полный адрес в "папке" >
if FileExists(s3) then
CopyFile(PChar(SlashSep(Path,v3.cFileName)),PChar(s1),true) else
if CreateDirectory(Pchar(s3),nil) then
CopyFile(PChar(SlashSep(Path,v3.cFileName)),PChar(s1),true); end; end;
while FindNextFile(a3,v3) do
if String(v3.cFileName) <> mnDirIn then
if String(v3.cFileName) <> mnDirNameUp then
if (v3.dwFileAttributes and FILE_ATTRIBUTE_DIRECTORY) > Zero then
FilesCopyIn(SlashSep(Path,v3.cFileName)) else begin
s1:=v3.cFileName;
a2:=Length(s1);
a1:=Pos(mnDot,s1);
if (a1 > One) and (a1 < a2) then begin
s2:=UpperCase(ExtractFileExt(s1)); // Только расширение >
s3:=mTrashPath+s2; // Адрес папки по расширеню >
s1:=s3+mnSlash+s1; // Полный адрес в "папке" >
if FileExists(s3) then
CopyFile(PChar(SlashSep(Path,v3.cFileName)),PChar(s1),true) else
if CreateDirectory(Pchar(s3),nil) then
CopyFile(PChar(SlashSep(Path,v3.cFileName)),PChar(s1),true); end; end;
FindClose(a3); end;
end;
  // Сканировать на предмет одинаковых файлов (и можно их порубать - лишние копии) >
function TMyFileTrash.RecurseCopyScan(bDelete: Boolean): Cardinal;
var a1,a2:Cardinal; f1:TMyFileStream;
begin
Result:=Zero;
if Clear then begin
ScanRecurse(mTrashPath);
if Count > One then begin
f1:=TMyFileStream.Create;
for a1:=Max downto One do
if OpenRead(PChar(mStrings[a1])) then
for a2:=a1-One downto Zero do
if f1.OpenRead(PChar(mStrings[a2])) then
if SimilarTo(f1,Zero) = mTrue then
if bDelete then begin
if Delete then
Inc(Result);
Break; end else begin
Inc(Result);
Break; end;
f1.Destroy; end;
Clear; end;
end;
  // Найти все файлы внутри "папки" >
procedure TMyFileTrash.ScanRecurse;
begin
Clear;
ScanRecurse(mTrashPath);
end;
//=============================================================================>
//================================== TMyUDB ===================================>
//=============================================================================>
constructor TMyUDB.Create(Value: TMyApplication);
begin // Конструктор >
inherited Create;
mApplication:=Value;
mDataTree:=TMyUDBTree.Create; // Дерево >
mDataTree.mUDBParent:=Self;
mDataTreeLinks:=TMyUDBLink.Create; // Ссылки >
mDataTreeLinks.mUDBParent:=Self;
mDataTreeAssosiations:=TMyUDBAssosiations.Create; // Связи >
mDataTreeAssosiations.mUDBParent:=Self;
mDataTreeParams:=TMyUDBNodeParams.Create; // Параметры >
mDataTreeParams.mUDBParent:=Self;
mTextAnalyser:=TMyTextAnalyser.Create(Self); // Тектовый анализатор >
mSenses:=TMyUDBSenses.Create; // Ощущения >
mSenses.mUDBParent:=Self;
end;
  // Деструктор >
destructor TMyUDB.Destroy;
begin
mDataTreeParams.Destroy; // Параметры >
mDataTreeAssosiations.Destroy; // Связи >
mDataTreeLinks.Destroy; // Ссылки >
mDataTree.Destroy; // Дерево >
mTextAnalyser.Destroy; // Анализатор текстовой информации >
mSenses.Destroy; // Ощущения >
inherited Destroy;
end;
  // Закрыть\отключить свяь с БД >
function TMyUDB.Close: Boolean;
begin
if Opened then
if mDataTreeParams.CloseFull then // Параметры >
if mDataTreeLinks.CloseFull then // Ссылки >
if mDataTreeAssosiations.CloseFull then // Связи >
if mSenses.CloseFull then // Ощущения >
if mDataTree.CloseFull then begin // Дерево >
mDBFileName:=EmptyString;
Result:=true; end else
Result:=false else
Result:=false else
Result:=false else
Result:=false else
Result:=false else
Result:=true;
end;
  // Уничтожить БД а диске, одновременно отключается от неё >
function TMyUDB.Erase: Boolean;
begin
if Opened then
if mDataTree.Delete then // Дерево >
if mDataTreeParams.Delete then // Параметры >
if mDataTreeAssosiations.Delete then // Связи >
if mSenses.Delete then // Ощущения >
if mDataTreeLinks.Delete then begin // Ссылки >
mDBFileName:=EmptyString;
Result:=true; end else
Result:=false else
Result:=false else
Result:=false else
Result:=false else
Result:=false else
Result:=false;
end;
  // Проверить, связана\подключена кака-нибудь БД >
function TMyUDB.Opened: Boolean;
begin
if mDataTreeAssosiations.Check then // Связи >
if mDataTreeLinks.Check then // Ссылки >
if mDataTreeParams.Check then // Параметры >
if mSenses.Check then // Ощущения >
Result:=mDataTree.Check else // Дерево >
Result:=false else
Result:=false else
Result:=false else
Result:=false;
end;
  // Создать БД >
function TMyUDB.Build(Value: String): Boolean;
begin
if mApplication = nil then
Result:=false else
if Value = EmptyString then
Result:=false else
if Close then begin
mDBFileName:=Value;
if mDataTreeAssosiations.OpenReadWrite(mApplication.FileTrash.FilePath(mDBFileName+cTMyBBName)) then
if mDataTreeParams.OpenReadWrite(mApplication.FileTrash.FilePath(mDBFileName+cTMyPBName)) then
if mDataTreeLinks.OpenReadWrite(mApplication.FileTrash.FilePath(mDBFileName+cTMyLBName)) then
if mSenses.OpenReadWrite(mApplication.FileTrash.FilePath(mDBFileName+cTMySBName)) then // Ощущения >
if mDataTree.OpenReadWrite(mApplication.FileTrash.FilePath(mDBFileName+cTMyDBName)) then
Result:=mDataTree.MakeFirstNode else
Result:=false else
Result:=false else
Result:=false else
Result:=false else
Result:=false; end else
Result:=false;
end;
  // "Загрузить"\подключиться к БД по такому-то имени БД >
function TMyUDB.Open(Value: String): Boolean;
begin
if mApplication = nil then
Result:=false else
if Value = EmptyString then
Result:=false else
if Close then begin
mDBFileName:=Value;
if FileExists(mApplication.FileTrash.FilePPath(mDBFileName+cTMyBBName)) and
   mDataTreeAssosiations.OpenReadWrite(mApplication.FileTrash.FilePath(mDBFileName+cTMyBBName)) then
if mDataTreeParams.OpenReadWrite(mApplication.FileTrash.FilePath(mDBFileName+cTMyPBName)) then
if mDataTreeLinks.OpenReadWrite(mApplication.FileTrash.FilePath(mDBFileName+cTMyLBName)) then
if mSenses.OpenReadWrite(mApplication.FileTrash.FilePath(mDBFileName+cTMySBName)) then // Ощущения >
Result:=mDataTree.OpenReadWrite(mApplication.FileTrash.FilePath(mDBFileName+cTMyDBName)) else
Result:=false else
Result:=false else
Result:=false else
Result:=false; end else
Result:=false;
end;
  // Создать копию данной БД, по указанному адресу >
function TMyUDB.Copy(Value: String; OverWrite: Boolean = true): Boolean;
begin
if mApplication = nil then
Result:=false else
if Value = EmptyString then
Result:=false else
if not Opened then
Result:=false else
if mDBFileName = Value then
Result:=true else
if mDataTreeAssosiations.Copy(mApplication.FileTrash.FilePath(mDBFileName+cTMyBBName),OverWrite) then
if mDataTreeParams.Copy(mApplication.FileTrash.FilePath(mDBFileName+cTMyPBName),OverWrite) then
if mDataTreeLinks.Copy(mApplication.FileTrash.FilePath(mDBFileName+cTMyLBName),OverWrite) then
if mSenses.Copy(mApplication.FileTrash.FilePath(mDBFileName+cTMySBName),OverWrite) then // Ощущения >
Result:=mDataTree.Copy(mApplication.FileTrash.FilePath(mDBFileName+cTMyDBName),OverWrite) else
Result:=false else
Result:=false else
Result:=false else
Result:=false;
end;
//=============================================================================>
//================================= TMyUDBLink ================================>
//=============================================================================>
constructor TMyUDBLink.Create;
begin // Конструктор >
inherited Create;
end;
  // Деструктор >
destructor TMyUDBLink.Destroy;
begin
inherited Destroy;
end;
  // Количество ссылок в списке >
function TMyUDBLink.Count: TMyHDMAddress;
begin
Result:=Size div cTMyHDMTreeLink;
end;
  // Возвращает адрес связанного узла (по номеру ссылки) >
function TMyUDBLink.LinkedNode(cNumber: Cardinal): TMyHDMAddress;
begin
if MapView(cNumber*cTMyHDMTreeLink,cTMyHDMTreeLink) then begin
Result:=PMyHDMTreeLink(CrntMapPointer)^.mParentNode;
UnViewMap; end else
Result:=mOne;
end;
  // Возвращает адрес связанного узла (по адресу ссылки) >
function TMyUDBLink.LinkedNode(const cLink: TMyHDMAddress): TMyHDMAddress;
begin
if MapView(cLink,cTMyHDMTreeLink) then begin
Result:=PMyHDMTreeLink(CrntMapPointer)^.mParentNode;
UnViewMap; end else
Result:=mOne;
end;
  // Возвращает адрес записи "параметров" связанного узла (по номеру ссылки) >
function TMyUDBLink.LinkedParams(cNumber: Cardinal): TMyHDMAddress;
begin
if MapView(cNumber*cTMyHDMTreeLink,cTMyHDMTreeLink) then begin
Result:=PMyHDMTreeLink(CrntMapPointer)^.mParams;
UnViewMap; end else
Result:=mOne;
end;
  // Возвращает адрес записи "параметров" связанного узла (по адресу ссылки) >
function TMyUDBLink.LinkedParams(const cLink: TMyHDMAddress): TMyHDMAddress;
begin
if MapView(cLink,cTMyHDMTreeLink) then begin
Result:=PMyHDMTreeLink(CrntMapPointer)^.mParams;
UnViewMap; end else
Result:=mOne;
end;
  // Сделать ссылку >
function TMyUDBLink.MakeLink(const cNode: TMyHDMAddress): TMyHDMAddress;
begin
Result:=Size;
Size:=Result+cTMyHDMTreeLink;
if MapView(Result,cTMyHDMTreeLink) then
with PMyHDMTreeLink(CrntMapPointer)^ do begin
mParentNode:=cNode;
mParams:=mOne;
mUsedTimes:=One;
UnViewMap; end;
end;
  // Сделать ссылку и поместить на второй её конец адрес на параметры узла, которые тоже - обновятся >
function TMyUDBLink.MakeLinkAndParams(const cNode: TMyHDMAddress): TMyHDMAddress;
begin
Result:=Size;
Size:=Result+cTMyHDMTreeLink;
if MapView(Result,cTMyHDMTreeLink) then
with PMyHDMTreeLink(CrntMapPointer)^ do begin
mParentNode:=cNode;
mParams:=mUDBParent.mDataTreeParams.MakeParams(cNode,Result);
mUsedTimes:=One;
UnViewMap; end;
end;
  // Наращивает счётчик числа обращений >
procedure TMyUDBLink.UpDateLink(const cLink: TMyHDMAddress);
begin
if MapView(cLink,cTMyHDMTreeLink) then
with PMyHDMTreeLink(CrntMapPointer)^ do begin
Inc(mUsedTimes);
if mUsedTimes > Twelve then
if mParams = mOne then
mParams:=mUDBParent.mDataTreeParams.MakeParams(mParentNode,cLink);
UnViewMap; end;
end;
  // Обновить "ссылку" и параметры, если они к этой ссылке привязаны >
procedure TMyUDBLink.UpDateLinkAndParams(const cLink: TMyHDMAddress);
begin
if MapView(cLink,cTMyHDMTreeLink) then
with PMyHDMTreeLink(CrntMapPointer)^ do begin
if mParams = mOne then
mParams:=mUDBParent.mDataTreeParams.MakeParams(mParentNode,cLink) else
mUDBParent.mDataTreeParams.UpDateParams(mParams);
Inc(mUsedTimes);
UnViewMap; end;
end;
//=============================================================================>
//=============================== TMyUDBNodeParams ============================>
//=============================================================================>
constructor TMyUDBNodeParams.Create;
begin // Конструктор >
inherited Create;
end;
  // Деструктор >
destructor TMyUDBNodeParams.Destroy;
begin
inherited Destroy;
end;
  // Посчитать, сколько записей "параметров" имеется в файле >
function TMyUDBNodeParams.Count: TMyHDMAddress;
begin
Result:=Size div cTMyHDMNodeParams;
end;
  // Создать запись параметров для данного узла, через его ссылку >
function TMyUDBNodeParams.MakeParams(const cNode,cLink: TMyHDMAddress): TMyHDMAddress;
begin
Result:=Size;
Size:=Result+cTMyHDMNodeParams;
if MapView(Result,cTMyHDMNodeParams) then
with PMyHDMNodeParams(CrntMapPointer)^ do begin
mParentNode:=cNode;
mParentLink:=cLink;
mFirstBind:=mOne;
mBindsCount:=Zero;
mDescription:=mOne;
mCreate:=GetMyTime; // Время создания >
mEdit:=mCreate; // Время последнего изменения >
mView:=mCreate; // Время последнего обращения\чтения >
mExtra:=mOne;
mReserved:=mOne;
UnViewMap; end;
end;
  // Обновить параметры >
procedure TMyUDBNodeParams.UpDateParams(const cParams: TMyHDMAddress);
begin
if MapView(cParams,cTMyHDMNodeParams) then
with PMyHDMNodeParams(CrntMapPointer)^ do begin
//mEdit:=GetMyTime; // Время последнего изменения >
mView:=mEdit; // Время последнего обращения\чтения >
UnViewMap; end;
end;
  // Связанная ссылка (по адресу) >
function TMyUDBNodeParams.ParamsLink(const cParams: TMyHDMAddress): TMyHDMAddress;
begin
if MapView(cParams,cTMyHDMNodeParams) then begin
Result:=PMyHDMNodeParams(CrntMapPointer)^.mParentLink;
UnViewMap; end else
Result:=mOne;
end;
  // Связанная ссылка (по номеру) >
function TMyUDBNodeParams.ParamsLink(cNumber: Cardinal): TMyHDMAddress;
begin
if MapView(cNumber*cTMyHDMNodeParams,cTMyHDMNodeParams) then begin
Result:=PMyHDMNodeParams(CrntMapPointer)^.mParentLink;
UnViewMap; end else
Result:=mOne;
end;
  // Связанный узел (по адресу) >
function TMyUDBNodeParams.ParamsNode(const cParams: TMyHDMAddress): TMyHDMAddress;
begin
if MapView(cParams,cTMyHDMNodeParams) then begin
Result:=PMyHDMNodeParams(CrntMapPointer)^.mParentNode;
UnViewMap; end else
Result:=mOne;
end;
  // Связанный узел (по номеру) >
function TMyUDBNodeParams.ParamsNode(cNumber: Cardinal): TMyHDMAddress;
begin
if MapView(cNumber*cTMyHDMNodeParams,cTMyHDMNodeParams) then begin
Result:=PMyHDMNodeParams(CrntMapPointer)^.mParentNode;
UnViewMap; end else
Result:=mOne;
end;
//=============================================================================>
//================================ TMyUDBBinding ==============================>
//=============================================================================>
constructor TMyUDBAssosiations.Create;
begin // Конструктор >
inherited Create;
end;
  // Деструктор >
destructor TMyUDBAssosiations.Destroy;
begin
inherited Destroy;
end;
  // Создать в первом указанном узле связь указанного типа на второй указанный узел >
function TMyUDBAssosiations.Bind(cNode1,cNode2: TMyHDMAddress): TMyHDMAddress;
var a1,v1,v2:TMyHDMAddress;
begin
if (cNode1 = mOne) or (cNode2 = mOne) then
v1:=mOne else
v1:=cNode1;
if v1 > mOne then
if mUDBParent.mDataTree.MapView(v1,cTMyHDMTreeNode) then begin
v1:=PMyHDMTreeNode(mUDBParent.mDataTree.CrntMapPointer)^.mLink;
if v1 > mOne then
if mUDBParent.mDataTreeLinks.MapView(v1,cTMyHDMTreeLink) then
with PMyHDMTreeLink(mUDBParent.mDataTreeLinks.CrntMapPointer)^ do begin
Inc(mUsedTimes);
v1:=mParams;
mUDBParent.mDataTreeLinks.UnViewMap; end else
v1:=mOne else
v1:=mOne;
mUDBParent.mDataTree.UnViewMap; end else
v1:=mOne;
if v1 = mOne then
Result:=mOne else
if mUDBParent.mDataTreeParams.MapView(v1,cTMyHDMNodeParams) then
with PMyHDMNodeParams(mUDBParent.mDataTreeParams.CrntMapPointer)^ do begin
mEdit:=GetMyTime;
v2:=mBindsCount;
if v2 = Zero then begin // Связей у этого узла нет никаких 8-) = делаем всё побыстрому... >
Result:=Size;                      
Size:=Result+cTMyHDMAssosiation;
if MapView(Result,cTMyHDMAssosiation) then
with PMyHDMAssosiation(CrntMapPointer)^ do begin
mParentBind:=v1; // Верхняя связь в списке >
mChildBind:=mOne; // Нижняя связь в списке >
mHostNode:=cNode1; // Родительский узел >
mTargetNode:=cNode2; // Целевой узел >
mCoeffitient:=mOne; // Коэфициент\калибровка точности >
UnViewMap; end;
mFirstBind:=Result;
mBindsCount:=One; end else begin
v1:=mFirstBind;
Result:=mOne;
for a1:=One to v2 do
if MapView(v1,cTMyHDMAssosiation) then
with PMyHDMAssosiation(CrntMapPointer)^ do
if (mHostNode = cNode1) and (mTargetNode = cNode2) then begin // Нужный тип связи найден - "останавливаем колесо" >
Result:=v1;
Break;
UnViewMap; end else begin
v2:=v1; // Верхняя связь в списке >
v1:=mChildBind; end; end;
if Result = mOne then begin // Если такой связи нет - создаём >
Result:=Size;
Size:=Result+cTMyHDMAssosiation;
if MapView(Result,cTMyHDMAssosiation) then
with PMyHDMAssosiation(CrntMapPointer)^ do begin
mParentBind:=v2; // Верхняя связь в списке >
mChildBind:=mOne; // Верхняя связь в списке >
mHostNode:=cNode1; // Родительский узел >
mTargetNode:=cNode2; // Целевой узел >
mCoeffitient:=mOne; // Коэфициент\калибровка точности >
UnViewMap; end;
Inc(mBindsCount); end;
mUDBParent.mDataTreeParams.UnViewMap; end else
Result:=mOne;
end;
  // Если связь указаного типа у первого указанного узла на второй указанный узел есть, то функция возвратит её адрес >
function TMyUDBAssosiations.Binded(cNode1,cNode2: TMyHDMAddress): TMyHDMAddress;
var a1,v1,v2:TMyHDMAddress;
begin
if (cNode1 = mOne) or (cNode2 = mOne) then
v1:=mOne else
v1:=cNode1;
if v1 > mOne then
if mUDBParent.mDataTree.MapView(v1,cTMyHDMTreeNode) then begin
v1:=PMyHDMTreeNode(mUDBParent.mDataTree.CrntMapPointer)^.mLink;
if v1 > mOne then
if mUDBParent.mDataTreeLinks.MapView(v1,cTMyHDMTreeLink) then begin
v1:=PMyHDMTreeLink(mUDBParent.mDataTreeLinks.CrntMapPointer)^.mParams;
mUDBParent.mDataTreeLinks.UnViewMap; end else
v1:=mOne else
v1:=mOne;
mUDBParent.mDataTree.UnViewMap; end else
v1:=mOne;
if v1 = mOne then
Result:=mOne else
if mUDBParent.mDataTreeParams.MapView(v1,cTMyHDMNodeParams) then begin
v2:=PMyHDMNodeParams(mUDBParent.mDataTreeParams.CrntMapPointer)^.mBindsCount;
if v2 = Zero then // Связей у этого узла нет ... >
Result:=mOne else begin
v1:=PMyHDMNodeParams(mUDBParent.mDataTreeParams.CrntMapPointer)^.mFirstBind;
Result:=mOne;
for a1:=One to v2 do
if MapView(v1,cTMyHDMAssosiation) then
with PMyHDMAssosiation(CrntMapPointer)^ do
if (mHostNode = cNode1) and (mTargetNode = cNode2) then begin // Нужный тип связи найден - "останавливаем колесо" >
Result:=v1;
UnViewMap;
Break; end else
v1:=mChildBind end;
mUDBParent.mDataTreeParams.UnViewMap; end else
Result:=mOne;
end;
  // >
function TMyUDBAssosiations.UnBind(cNode1,cNode2: TMyHDMAddress): TMyHDMAddress;
begin

end;
//=============================================================================>
//=============================== TMyTextAnalyser =============================>
//=============================================================================>
constructor TMyTextAnalyser.Create(Value: TMyUDB);
begin // Конструктор >
inherited Create;
mUDB:=Value;
end;
  // Деструктор >
destructor TMyTextAnalyser.Destroy;
begin
inherited Destroy;
end;
  // Разобрать текстовый файл на слова и запомнить их >
function TMyTextAnalyser.ReadAndRememderWords(Path: PChar): Boolean;
var a1,a2:Cardinal; p1,p3:PMyString; p2,p4:PBytePack;
begin
if OpenRead(Path) then begin
p1:=MyStringCreate; // Строка, в которую читает файл >
p2:=MyStringGetPBytePack(p1); // Указатель на неё (первую строку), как на набор байт, с места начала анализа >
p3:=MyStringCreate; // Строка, которую анализирует алгоритм деления на слова >
p4:=MyStringGetPBytePack(p3); // Указатель на неё (вторую строку - которя должна содержать одно слово или пустоту), как на набор байт, с места начала анализа >
a2:=p1^.mSize;
while ReadLn(p1) do begin
p3^.mUsedSize:=Zero;
if p1^.mSize > a2 then begin
p2:=MyStringGetPBytePack(p1);
a2:=p1^.mSize; end;
if p1^.mUsedSize > Zero then
for a1:=Zero to p1^.mUsedSize-One do // Цикл разделения на cлова (НАЧАЛО) =====>
if mCharCodes[p2^[a1]] then begin
p4[p3^.mUsedSize]:=p2^[a1];
Inc(p3^.mUsedSize); end else
if p3^.mUsedSize > Zero then begin
mUDB.mDataTree.Add(p3);
p3^.mUsedSize:=Zero; end;
if p3^.mUsedSize > Zero then
mUDB.mDataTree.Add(p3); end; // Цикл разделения на cлова (КОНЕЦ) ==============>
MyStringDestroy(p1);
MyStringDestroy(p3);
Result:=Close; end else
Result:=false;
end;
  // Записать в этот список все "слова", которые сохранены с параметрами >
function TMyTextAnalyser.ExtractNodesWithParams: Boolean;
var a1,a2:TMyHDMAddress; s1:String;
begin
a2:=mUDB.mDataTreeParams.Count;
OpenReadWrite('ViewWords.txt');
if a2 = Zero then
Result:=true else begin
for a1:=Zero to a2-One do
if mUDB.mDataTreeParams.MapView(a1*cTMyHDMNodeParams,cTMyHDMNodeParams) then begin
if mUDB.mDataTree.Get(PMyHDMNodeParams(mUDB.mDataTreeParams.CrntMapPointer)^.mParentNode,s1) then
WriteLn(s1);
mUDB.mDataTreeParams.UnViewMap; end;
Result:=Size > Zero; end;
CloseFull;
end;
//=============================================================================>
//================================= TMyUDBSenses ==============================>
//=============================================================================>
constructor TMyUDBSenses.Create;
begin // Конструктор >
inherited Create;
end;
  // Деструктор >
destructor TMyUDBSenses.Destroy;
begin
inherited Destroy;
end;
//=============================================================================>
//================================= TMyUDBTree ================================>
//=============================================================================>
constructor TMyUDBTree.Create;
begin // Конструктор >
inherited Create;
SetLength(mNodeBuff,Zero);
mNodeBuffHigh:=mOne;
mNodeBuffCount:=Zero;
mNodeBuffCapasity:=Zero;
mNodeBuffCapasityInc:=_32;
BuffSetLength(mNodeBuffCapasityInc);
end;
  // Деструктор >
destructor TMyUDBTree.Destroy;
begin
BuffDestroy;
inherited Destroy;
end;
  // Установить ёмкость списка-буффера для считывания узлов дерева >
function TMyUDBTree.BuffSetCount(Value: Cardinal): Boolean;
var a1:Cardinal;
begin
a1:=((Value div mNodeBuffCapasityInc)+One)*mNodeBuffCapasityInc;
if mNodeBuffCapasity < a1 then try
SetLength(mNodeBuff,a1);
mNodeBuffCapasity:=a1;
mNodeBuffCount:=Value;
mNodeBuffHigh:=mNodeBuffCount-One;
Result:=mNodeBuffCount = Value; except
Result:=false; end else
Result:=true;
end;
  // Онулить список-буффер узлов >
function TMyUDBTree.BuffClear: Boolean;
begin
if mNodeBuffCount = Zero then
Result:=true else
Result:=BuffSetCount(Zero);
end;
  // Установить ёмкость и "наполнить памятью" список-буффер >
function TMyUDBTree.BuffSetLength(Value: Cardinal): Boolean;
var a1,a2:Cardinal;
begin
if Value <= mNodeBuffCount then
Result:=true else begin
a2:=mNodeBuffCount;
if BuffSetCount(Value) then try
for a1:=a2 to mNodeBuffHigh do begin
GetMem(mNodeBuff[a1],cTMyHDMTreeNode);
FillWithZero(mNodeBuff[a1],cTMyHDMTreeNode); end;
Result:=true; except
Result:=false; end else
Result:=false; end;
end;
  // Уничтожить\обнулить список-буффер узлов и освободить выделеную для него память >
function TMyUDBTree.BuffDestroy: Boolean;
var a1:Cardinal;
begin
if mNodeBuffCount = Zero then
Result:=true else try
for a1:=Zero to mNodeBuffHigh do begin
FreeMem(mNodeBuff[a1],cTMyHDMTreeNode);
mNodeBuff[a1]:=nil; end;
Result:=BuffClear; except
Result:=false; end;
end;
  // Посчитать количество узлов в дереве >
function TMyUDBTree.Count: TMyHDMAddress;
var v1:TMyHDMAddress;
begin
v1:=Size;
if v1 = Zero then
Result:=mOne else
Result:=v1 div cTMyHDMTreeNode;
end;
  // Очистить параметры узла - для нулевого использования >
function TMyUDBTree.MakeFirstNode: Boolean;
var a1:Cardinal;
begin
Size:=cTMyHDMTreeNode;
if MapView(Zero,cTMyHDMTreeNode) then
with PMyHDMTreeNode(CrntMapPointer)^ do begin
for a1:=Zero to ByteMax do
mChildNodes[a1]:=mOne;
mParentNode:=mOne;
mParentIndex:=mOne;
mHeight:=Zero;
mLink:=mOne;
Result:=UnViewMap; end else
Result:=false;
end;
  // Записать в дерево строку "PChar" >
function TMyUDBTree.Add(const pData: PChar; cType: Cardinal = Zero): TMyHDMAddress;
var a1,a2,a3:Cardinal; v1,v2:TMyHDMAddress; p1:PBytePack;
begin
if pData = nil then
Result:=mOne else
if MapView(Zero,cTMyHDMTreeNode) then begin
p1:=Pointer(pData);
v1:=Zero;
a2:=PCharLength(pData)-One;
for a1:=Zero to a2 do begin
v2:=PMyHDMTreeNode(CrntMapPointer)^.mChildNodes[p1^[a1]];
if v2 = mOne then begin
v2:=Size;
PMyHDMTreeNode(CrntMapPointer)^.mChildNodes[p1^[a1]]:=v2;
Size:=v2+cTMyHDMTreeNode;
MapView(v2,cTMyHDMTreeNode);
with PMyHDMTreeNode(CrntMapPointer)^ do begin // Заполняем текущие записи узла значениями >
for a3:=Zero to ByteMax do // Проходим по всему массиву адресов дочерних узлов >
mChildNodes[a3]:=mOne; // Записываем "отсутствие адреса" >
mParentNode:=v1; // Адрес родительского узла >
mParentIndex:=p1^[a1]; // Номер адреса текущего узла в списке дочерних адресов родительского по отношению к данному узла >
mHeight:=a1+One; // Расстояние до первого узла >
if a1 = a2 then // Достигнут верхний (конечный) узел для записи - что дальше... >
case cType of // Адрес ссылки данного узла пуст - что делать? >
  Zero: mLink:=mUDBParent.mDataTreeLinks.MakeLinkAndParams(v2);
  One: mLink:=mUDBParent.mDataTreeLinks.MakeLink(v2); // Создаём и прикрепляем ссылку >
  else mLink:=mOne; end else
mLink:=mOne; end;
v1:=v2; end else begin
MapView(v2,cTMyHDMTreeNode);
if a1 = a2 then
with PMyHDMTreeNode(CrntMapPointer)^ do
case cType of // Адрес ссылки данного узла пуст - что делать? >
  Zero: if mLink = mOne then
    mLink:=mUDBParent.mDataTreeLinks.MakeLinkAndParams(v2) else
    mUDBParent.mDataTreeLinks.UpDateLinkAndParams(mLink);
  One: if mLink = mOne then
    mLink:=mUDBParent.mDataTreeLinks.MakeLink(v2) else
    mUDBParent.mDataTreeLinks.UpDateLink(mLink); end;
v1:=v2; end; end;
Result:=v1;
UnViewMap; end else
Result:=mOne;
end;
  // Записать в дерево абстрактные данные >
function TMyUDBTree.Add(pData: Pointer; cSize: TMyHDMAddress; cType: Cardinal = Zero): TMyHDMAddress;
var a1,a2,a3:Cardinal; v1,v2:TMyHDMAddress; p1:PBytePack;
begin
if pData = nil then
Result:=mOne else
if cSize < One then
Result:=mOne else
if MapView(Zero,cTMyHDMTreeNode) then begin
p1:=Pointer(pData);
v1:=Zero;
a2:=cSize - One;
for a1:=Zero to a2 do begin
v2:=PMyHDMTreeNode(CrntMapPointer)^.mChildNodes[p1^[a1]];
if v2 = mOne then begin
v2:=Size;
PMyHDMTreeNode(CrntMapPointer)^.mChildNodes[p1^[a1]]:=v2;
Size:=v2+cTMyHDMTreeNode;
MapView(v2,cTMyHDMTreeNode);
with PMyHDMTreeNode(CrntMapPointer)^ do begin // Заполняем текущие записи узла значениями >
for a3:=Zero to ByteMax do // Проходим по всему массиву адресов дочерних узлов >
mChildNodes[a3]:=mOne; // Записываем "отсутствие адреса" >
mParentNode:=v1; // Адрес родительского узла >
mParentIndex:=p1^[a1]; // Номер адреса текущего узла в списке дочерних адресов родительского по отношению к данному узла >
mHeight:=a1+One; // Расстояние до первого узла >
if a1 = a2 then // Достигнут верхний (конечный) узел для записи - что дальше... >
case cType of // Адрес ссылки данного узла пуст - что делать? >
  Zero: mLink:=mUDBParent.mDataTreeLinks.MakeLinkAndParams(v2);
  One: mLink:=mUDBParent.mDataTreeLinks.MakeLink(v2); // Создаём и прикрепляем ссылку >
  else mLink:=mOne; end else
mLink:=mOne; end;
v1:=v2; end else begin
MapView(v2,cTMyHDMTreeNode);
if a1 = a2 then
with PMyHDMTreeNode(CrntMapPointer)^ do
case cType of
  Zero: if mLink = mOne then
    mLink:=mUDBParent.mDataTreeLinks.MakeLinkAndParams(v2) else
    mUDBParent.mDataTreeLinks.UpDateLinkAndParams(mLink);
  One: if mLink = mOne then
    mLink:=mUDBParent.mDataTreeLinks.MakeLink(v2) else
    mUDBParent.mDataTreeLinks.UpDateLink(mLink); end;
v1:=v2; end; end;
Result:=v1;
UnViewMap; end else
Result:=mOne;
end;
  // Записать в дерево строку "String" >
function TMyUDBTree.Add(const Value: String; cType: Cardinal = Zero): TMyHDMAddress;
var a1,a2,a3:Cardinal; v1,v2:TMyHDMAddress;
begin
a2:=Length(Value);
if a2 = Zero then
Result:=mOne else
if MapView(Zero,cTMyHDMTreeNode) then begin
v1:=Zero;
for a1:=One to a2 do begin
v2:=PMyHDMTreeNode(CrntMapPointer)^.mChildNodes[Byte(Value[a1])];
if v2 = mOne then begin
v2:=Size;
PMyHDMTreeNode(CrntMapPointer)^.mChildNodes[Byte(Value[a1])]:=v2;
Size:=v2+cTMyHDMTreeNode;
MapView(v2,cTMyHDMTreeNode);
with PMyHDMTreeNode(CrntMapPointer)^ do begin // Заполняем текущие записи узла значениями >
for a3:=Zero to ByteMax do // Проходим по всему массиву адресов дочерних узлов >
mChildNodes[a3]:=mOne; // Записываем "отсутствие адреса" >
mParentNode:=v1; // Адрес родительского узла >
mParentIndex:=Byte(Value[a1]); // Номер адреса текущего узла в списке дочерних адресов родительского по отношению к данному узла >
mHeight:=a1; // Расстояние до первого узла >
if a1 = a2 then // Достигнут верхний (конечный) узел для записи - что дальше... >
case cType of // Адрес ссылки данного узла пуст - что делать? >
  Zero: mLink:=mUDBParent.mDataTreeLinks.MakeLinkAndParams(v2);
  One: mLink:=mUDBParent.mDataTreeLinks.MakeLink(v2); // Создаём и прикрепляем ссылку >
  else mLink:=mOne; end else
mLink:=mOne; end;
v1:=v2; end else begin
MapView(v2,cTMyHDMTreeNode);
if a1 = a2 then
with PMyHDMTreeNode(CrntMapPointer)^ do
case cType of
  Zero: if mLink = mOne then
    mLink:=mUDBParent.mDataTreeLinks.MakeLinkAndParams(v2) else
    mUDBParent.mDataTreeLinks.UpDateLinkAndParams(mLink);
  One: if mLink = mOne then
    mLink:=mUDBParent.mDataTreeLinks.MakeLink(v2) else
    mUDBParent.mDataTreeLinks.UpDateLink(mLink); end;
v1:=v2; end; end;
Result:=v1;
UnViewMap; end else
Result:=mOne;
end;
  // Записать в дерево "PMyString" >
function TMyUDBTree.Add(pData: PMyString; cType: Cardinal = One): TMyHDMAddress;
var a1,a2,a3:Cardinal; v1,v2:TMyHDMAddress; p1:PBytePack;
begin
if pData = nil then
a2:=Zero else
a2:=pData^.mUsedSize;
if a2 = Zero then
Result:=mOne else
if MapView(Zero,cTMyHDMTreeNode) then begin
v1:=Zero;
p1:=Pointer(pData);
for a1:=One to a2 do begin
v2:=PMyHDMTreeNode(CrntMapPointer)^.mChildNodes[p1^[a1+cMyStringSize-One]];
if v2 = mOne then begin
v2:=Size;
PMyHDMTreeNode(CrntMapPointer)^.mChildNodes[p1^[a1+cMyStringSize-One]]:=v2;
Size:=v2+cTMyHDMTreeNode;
MapView(v2,cTMyHDMTreeNode);
with PMyHDMTreeNode(CrntMapPointer)^ do begin // Заполняем текущие записи узла значениями >
for a3:=Zero to ByteMax do // Проходим по всему массиву адресов дочерних узлов >
mChildNodes[a3]:=mOne; // Записываем "отсутствие адреса" >
mParentNode:=v1; // Адрес родительского узла >
mParentIndex:=p1^[a1+cMyStringSize-One]; // Номер адреса текущего узла в списке дочерних адресов родительского по отношению к данному узла >
mHeight:=a1; // Расстояние до первого узла >
if a1 = a2 then // Достигнут верхний (конечный) узел для записи - что дальше... >
case cType of // Адрес ссылки данного узла пуст - что делать? >
  Zero: mLink:=mUDBParent.mDataTreeLinks.MakeLinkAndParams(v2);
  One: mLink:=mUDBParent.mDataTreeLinks.MakeLink(v2); // Создаём и прикрепляем ссылку >
  else mLink:=mOne; end else
mLink:=mOne; end;
v1:=v2; end else begin
MapView(v2,cTMyHDMTreeNode);
if a1 = a2 then
with PMyHDMTreeNode(CrntMapPointer)^ do
case cType of
  Zero: if mLink = mOne then
    mLink:=mUDBParent.mDataTreeLinks.MakeLinkAndParams(v2) else
    mUDBParent.mDataTreeLinks.UpDateLinkAndParams(mLink);
  One: if mLink = mOne then
    mLink:=mUDBParent.mDataTreeLinks.MakeLink(v2) else
    mUDBParent.mDataTreeLinks.UpDateLink(mLink); end;
v1:=v2; end; end;
Result:=v1;
UnViewMap; end else
Result:=mOne;
end;
  // >
function TMyUDBTree.Get(Address: TMyHDMAddress; pData: PMyString): Boolean;
var a1,a2:Cardinal; p1:PBytePack;
begin
if pData = nil then
Result:=false else
with pData^ do
if Address = Zero then begin
mUsedSize:=Zero;
Result:=true; end else
if Address < Zero then begin
mUsedSize:=Zero;
Result:=false; end else
if MapView(Address,cTMyHDMTreeNode) then begin
with PMyHDMTreeNode(CrntMapPointer)^ do begin
Address:=mParentNode;
a2:=mHeight;
mUsedSize:=a2;
p1:=Pointer(pData);
p1^[a2+cMyStringSize-One]:=Byte(mParentIndex); end;
for a1:=a2-One downto One do begin
MapView(Address,cTMyHDMTreeNode);
with PMyHDMTreeNode(CrntMapPointer)^ do begin
Address:=mParentNode;
p1^[a1+cMyStringSize-One]:=mParentIndex; end; end;
Result:=UnViewMap; end else begin
mUsedSize:=Zero;
Result:=false; end;
end;
  // Извлечь по адресу узла его путь в виде "дэлфи-строки" >
function TMyUDBTree.Get(Address: TMyHDMAddress; out Value: String): Boolean;
var a1,a2:Cardinal;
begin
if Address = Zero then begin
Value:=EmptyString;
Result:=true; end else
if Address < Zero then begin
Value:=EmptyString;
Result:=false; end else
if MapView(Address,cTMyHDMTreeNode) then begin
with PMyHDMTreeNode(CrntMapPointer)^ do begin
Address:=mParentNode;
a2:=mHeight;
SetLength(Value,a2);
Value[a2]:=Char(mParentIndex); end;
for a1:=a2-One downto One do begin
MapView(Address,cTMyHDMTreeNode);
with PMyHDMTreeNode(CrntMapPointer)^ do begin
Address:=mParentNode;
Value[a1]:=Char(Byte(mParentIndex)); end; end;
Result:=UnViewMap; end else begin
Value:=EmptyString;
Result:=false; end;
end;
  // Извлечь по адресу узла его путь в виде "нуль-терминальной строки" >
function TMyUDBTree.Get(Address: TMyHDMAddress; out pData: PChar): Boolean;
var a1,a2:Cardinal; p1:Pointer;
begin
if Address = Zero then begin
pData:=PChar(EmptyString);
Result:=true; end else
if Address < Zero then begin
pData:=PChar(EmptyString);
Result:=false; end else
if MapView(Address,cTMyHDMTreeNode) then begin
with PMyHDMTreeNode(CrntMapPointer)^ do begin
Address:=mParentNode;
a2:=mHeight;
GetMem(p1,a2+One);
PBytePack(p1)^[a2]:=Zero;
PBytePack(p1)^[a2-One]:=mParentIndex; end;
for a1:=a2-One downto One do begin
MapView(Address,cTMyHDMTreeNode);
with PMyHDMTreeNode(CrntMapPointer)^ do begin
Address:=mParentNode;
PBytePack(p1)^[a1-One]:=mParentIndex; end; end;
pData:=p1;
Result:=UnViewMap; end else begin
pData:=PChar(EmptyString);
Result:=false; end;
end;
  // Извлечь по адресу узла его путь в виде "абстрактных данных" >
function TMyUDBTree.Get(Address: TMyHDMAddress; out pData: Pointer; var cSize: Cardinal): Boolean;
var a1:Cardinal;
begin
if Address = Zero then begin
pData:=PChar(EmptyString);
cSize:=Zero;
Result:=true; end else
if Address < Zero then begin
pData:=PChar(EmptyString);
cSize:=Zero;
Result:=false; end else
if MapView(Address,cTMyHDMTreeNode) then begin
with PMyHDMTreeNode(CrntMapPointer)^ do begin
Address:=mParentNode;
cSize:=mHeight;
GetMem(pData,cSize);
PBytePack(pData)^[cSize-One]:=mParentIndex; end;
for a1:=cSize-One downto One do begin
MapView(Address,cTMyHDMTreeNode);
with PMyHDMTreeNode(CrntMapPointer)^ do begin
Address:=mParentNode;
PBytePack(pData)^[a1-One]:=mParentIndex; end; end;
Result:=UnViewMap; end else begin
pData:=PChar(EmptyString);
cSize:=Zero;
Result:=false; end;
end;
  // Адрес по "содержимому" >
function TMyUDBTree.Address(const Value: String): TMyHDMAddress;
var a1,a2:Cardinal;
begin
Result:=mOne;
a2:=Length(Value);
if a2 > Zero then
if MapView(Zero,cTMyHDMTreeNode) then begin
for a1:=One to a2 do
with PMyHDMTreeNode(CrntMapPointer)^ do begin
Result:=mChildNodes[Byte(Value[a1])];
if Result = mOne then
Break else
MapView(Result,cTMyHDMTreeNode); end;
UnViewMap; end;
end;
  // "Связь" по "содержимому" >
function TMyUDBTree.Link(const Value: String): TMyHDMAddress;
var a1,a2:Cardinal;
begin
Result:=mOne;
a2:=Length(Value);
if a2 > Zero then
if MapView(Zero,cTMyHDMTreeNode) then begin
for a1:=One to a2 do
with PMyHDMTreeNode(CrntMapPointer)^ do begin
Result:=mChildNodes[Byte(Value[a1])];
if Result = mOne then
Break else
MapView(Result,cTMyHDMTreeNode); end;
if Result > mOne then
Result:=PMyHDMTreeNode(CrntMapPointer)^.mLink;
UnViewMap; end;
end;
  // >
function TMyUDBTree.Info(const Value: String): String;
var a1,a2:Cardinal; v1:TMyHDMAddress;
begin
Result:=EmptyString;
a2:=Length(Value);
if a2 > Zero then
if MapView(Zero,cTMyHDMTreeNode) then begin
v1:=mOne;
for a1:=One to a2 do
with PMyHDMTreeNode(CrntMapPointer)^ do begin
v1:=mChildNodes[Byte(Value[a1])];
if (v1 = mOne) or (mHeight = a2) then
Break else
MapView(v1,cTMyHDMTreeNode); end;
if v1 > mOne  then begin
v1:=PMyHDMTreeNode(CrntMapPointer)^.mLink;
if v1 > mOne then
if mUDBParent.mDataTreeLinks.MapView(v1,cTMyHDMTreeLink) then
with PMyHDMTreeLink(mUDBParent.mDataTreeLinks.CrntMapPointer)^ do begin
Result:='Used Times = '+IntToStr(mUsedTimes);
Inc(mUsedTimes); end; end;
UnViewMap; end;
end;
//=============================================================================>
//==================================== TMyCPU =================================>
//=============================================================================>
constructor TMyCPU.Create;
var TimerHi,TimerLo:Cardinal; PriorityClass,Priority:Integer;
begin // Конструктор >
inherited Create;
PriorityClass:=GetPriorityClass(GetCurrentProcess);
Priority:=GetThreadPriority(GetCurrentThread);
SetPriorityClass(GetCurrentProcess,REALTIME_PRIORITY_CLASS);
SetThreadPriority(GetCurrentThread,THREAD_PRIORITY_TIME_CRITICAL);
Sleep(Ten);
asm
dw 310Fh
mov TimerLo, eax
mov TimerHi, edx
end;
Sleep(mCPUDT);
asm
dw 310Fh
sub eax, TimerLo
sbb edx, TimerHi
mov TimerLo, eax
mov TimerHi, edx
end;
SetThreadPriority(GetCurrentThread,Priority);
SetPriorityClass(GetCurrentProcess,PriorityClass);
mCPUSpeed:=(TimerLo/mCPUDT)/_1000;
end;
  // Деструктор >
destructor TMyCPU.Destroy;
begin
inherited Destroy;
end;
//=============================================================================>
//================================== TMyWindows ===============================>
//=============================================================================>
constructor TMyWindows.Create;
var v1:TOSVersionInfo; mBuff:TMySystemPath;
begin // Конструктор >
inherited Create;
MyType:=mnWindows;
v1.dwOSVersionInfoSize:=SizeOf(v1);
if GetVersionEx(v1) then begin
mCSDVersion:=String(v1.szCSDVersion);
mBuild:=v1.dwBuildNumber;
mMajorVersion:=v1.dwMajorVersion;
mMinorVersion:=v1.dwMinorVersion;
mPlatformId:=v1.dwPlatformId;
GetSystemDirectory(@mBuff,MAX_PATH);
mNucleusName:=String(mBuff);
mNucleusPath:=ExtractFilePath(NucleusPath); end;
GetWindowsList;
end;
  // Деструктор >
destructor TMyWindows.Destroy;
begin
inherited;
end;
  // Для завершения сессии "Винды" >
function TMyWindows.ExitSession(cType: Cardinal; cPrivilege: Boolean = false): Boolean;
begin
if cPrivilege then
if ActivateMyPrivilege(mniShutdown,cPrivilege) then begin
Result:=ExitWindowsEx(cType,Zero);
ActivateMyPrivilege(mniShutdown,not cPrivilege); end else
Result:=false else
Result:=ExitWindowsEx(cType,Zero);
end;
  // >
procedure TMyWindows.GetWindowsList;
var a1,a2,a3:Cardinal; s1:array [0..127] of Char;
begin
//if EnumWindows(nil,zero) then
//ShowMessage('yes');
              {
a3:=300;
a1:=GetWindow(GetStartButtonHandle,GW_HWNDFIRST);
while a3 > 0 do begin
GetWindowText(a1,@s1,SizeOf(s1));
ShowMessage(String(s1));
a1:=GetWindow(a1,GW_HWNDNEXT);
Dec(a3); end;}
{
 Wnd : hWnd;
 buff: array [0..127] of Char;
begin
 ListBox1.Clear;
 Wnd:=GetWindow(Handle, gw_HWndFirst);
 while Wnd<>0 do
  begin //Не показываем:
   if (Wnd<>Application.Handle) and //-Собственное окно
   (IsWindowVisible(Wnd)or checkbox1.checked) and //-Невидимые окна
   ((GetWindow(Wnd, gw_Owner)=0) or checkbox2.checked) and //-Дочернии окна
   (GetWindowText(Wnd, buff, sizeof(buff))<>0) //-Окна без заголовков
    then
     begin
      GetWindowText(Wnd, buff, sizeof(buff));
      ListBox1.Items.Add(StrPas(buff));
     end;
    Wnd:=GetWindow(Wnd, gw_hWndNext);
}
end;
//=============================================================================>
//=================================== TMyRAM ==================================>
//=============================================================================>
constructor TMyRAM.Create;
begin // Конструктор >
inherited Create;
MyType:=mnRAMClass;
UpDate;
end;
  // Обновить сведения об оперативной памяти >
function TMyRAM.UpDate: Boolean;
var v1:TMemoryStatus;
begin
v1.dwLength:=SizeOf(v1); try
GlobalMemoryStatus(v1);
mMemoryLoad:=v1.dwMemoryLoad;
mTotalPhysical:=v1.dwTotalPhys;
mAvailPhysical:=v1.dwAvailPhys;
mUsedPhysical:=mTotalPhysical-mAvailPhysical;
mTotalPageFile:=v1.dwAvailVirtual;
mAvailPageFile:=v1.dwTotalVirtual;
mUsedPageFile:=mTotalPageFile-mAvailPageFile;
mTotalVirtual:=v1.dwAvailPageFile;
mAvailVirtual:=v1.dwTotalPageFile;
mUsedVirtual:=mTotalVirtual-mAvailVirtual;
Result:=true; except
Result:=false; end;
end;
  // Деструктор >
destructor TMyRAM.Destroy;
begin
inherited Destroy;
end;
//=============================================================================>
//================================ TMyProcessList =============================>
//=============================================================================>
constructor TMyProcessList.Create(Value: TMyApplication = nil);
begin // Конструктор >
inherited Create;
mApplication:=Value;
mAllKnownList:=TMyStringList.Create;
mAllKnownList.LoadFromTextFile(mApplication.FileTrash.FilePath(mnAllProcList));
mSystemList:=TMyStringList.Create;
mBad:=TMyStringList.Create;
UpDate;
end;
  // Деструктор >
destructor TMyProcessList.Destroy;
begin
mAllKnownList.SaveToTextFile(mApplication.FileTrash.FilePath(mnAllProcList));
mAllKnownList.Destroy;
mSystemList.SaveToTextFile(mApplication.FileTrash.FilePath(mnSystemProcList));
mSystemList.Destroy;
mBad.SaveToTextFile(mApplication.FileTrash.FilePath(mnBadProcList));
mBad.Destroy;
inherited Destroy;
end;
  // Получить данные на процесс >
function TMyProcessList.GetProcess(Index: Cardinal): PMyProcParams;
begin
if mProcCount = Zero then
Result:=nil else
if Index < mProcCount then
Result:=@mProc[Index] else
Result:=nil;
end;
  // Остановить процесс по указанному индексу >
function TMyProcessList.Terminate(Index: Cardinal): Boolean;
var a1:Cardinal;
begin
if Index < mProcCount then
a1:=OpenProcess(PROCESS_TERMINATE,false,mProc[Index].mPID) else // Получаем дескриптор процесса для его завершения >
a1:=Zero;
if a1 = Zero then
Result:=false else begin
Result:=TerminateProcess(a1,Cardinal(mOne)); // Завершаем процесс >
CloseHandle(a1); end;
end;
  // Остановить процесс с превилегие отладки >
function TMyProcessList.TerminateDebug(Index: Cardinal): Boolean;
begin
if ActivateMyPrivilege(mniDebug,true) then begin
Result:=Terminate(Index);
ActivateMyPrivilege(mniDebug,false); end else
Result:=false;
end;
  // Уничтожить свой процесс >
function TMyProcessList.TerminateSelf: Boolean;
begin
Result:=Terminate(IndexOf(mApplication.mName+mnDot+mnEXE));
end;
  // Возвращает номер переданного названия в списке, если такого нет, то -1 >
function TMyProcessList.IndexOf(Value: String): Integer;
var a1:Cardinal;
begin
Result:=mOne;
if mProcCount > Zero then
for a1:=Zero to mProcHigh do
if mProc[a1].Name = Value then begin
Result:=a1;
Break; end;
end;
  // Обновить список процессов >
function TMyProcessList.Refresh: Boolean;
var mPE:TProcessEntry32; a1:Cardinal;
begin
SetLength(mProc,Zero);
mProcCount:=Zero;
mProcHigh:=mOne;
a1:=CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS,Zero);
if a1 = INVALID_HV then
Result:=false else
with mPE do begin
dwSize:=SizeOf(mPE);
if Process32First(a1,mPE) then begin
Inc(mProcCount);
Inc(mProcHigh);
SetLength(mProc,mProcCount);
mProc[mProcHigh].Name:=szExeFile;
mProc[mProcHigh].mPID:=th32ProcessID;
while Process32Next(a1,mPE) do begin
Inc(mProcCount);
Inc(mProcHigh);
SetLength(mProc,mProcCount);
mProc[mProcHigh].Name:=szExeFile;
mProc[mProcHigh].mPID:=th32ProcessID; end; end;
Result:=CloseHandle(a1); end;
end;
  // Выполнить проверку процессов >
function TMyProcessList.UpDate: Boolean;
var a1,a2:Cardinal;
begin
if Refresh then
if mProcCount > Zero then
if Assigned(mApplication) then try
a2:=Zero;
for a1:=Zero to mProcHigh do
if mAllKnownList.IndexOf(mProc[a1].Name) = mOne then begin
mAllKnownList.Add(mProc[a1].Name);
Inc(a2); end;
if a2 > Zero then
mAllKnownList.SaveToTextFile(mApplication.FileTrash.FilePath(mnAllProcList));
if mBad.LoadFromTextFile(mApplication.FileTrash.FilePath(mnBadProcList)) then
if mBad.Count > Zero then begin
for a1:=Zero to mProcHigh do
if mBad.IndexOf(mProc[a1].Name) > mOne then
if TerminateDebug(a1) then
mApplication.Log.WriteLog(mnl_SKIP_3,mnl_PROCESS_STOPED,mProc[a1].Name);
mBad.Clear; end;
Result:=true; except
Result:=false; end else
Result:=false else
Result:=false else
Result:=false;
end;
//=============================================================================>
//=============================== TMyNodeExplorer =============================>
//=============================================================================>
constructor TMyNodeExplorer.Create(Value: TMyNode);
begin // Конструктор >
inherited Create;
mName:=GetWindowsUserName;
SetPosition(Value);
end;
  // Деструктор >
destructor TMyNodeExplorer.Destroy;
begin
inherited Destroy;
end;
  // Установить положение >
procedure TMyNodeExplorer.SetPosition(Value: TMyNode);
begin
if Value = nil then
Exit else
if Value = mPosition then
Exit else begin
//if Assigned(mPosition) then
//mPosition.OnExit;
//Value.OnEnter;
mPosition:=Value; end;
end;
//=============================================================================>
//=================================== TMyDrive ================================>
//=============================================================================>
constructor TMyDrive.Create(Value: Char);
begin // Конструктор >
inherited Create;
MyType:=mnDrive;
mName:=Value;
pParams:=@mParams;
UpDate;
end;
  // Деструктор >
destructor TMyDrive.Destroy;
begin
inherited Destroy;
end;
  // Обновить данные о диске\приводе\устройстве\разделе\... >
function TMyDrive.UpDate: Boolean;
var MaxComponentLength:Cardinal; vName,vFileSystem:TMySystemPath; //p1:PChar;
begin
with mParams,Additional do
if GetVolumeInformation(FullPath,@vName,MAX_PATH,@SerialNumber,MaxComponentLength,FileSystemFlags,@vFileSystem,MAX_PATH) then begin
FileSystem:=String(vFileSystem);
VolumeLabel:=String(vName);
DriveType:=GetDriveType(FullPath);
if GetDiskFreeSpace(FullPath,SectorsPerCluster,BytesPerSector,NumberOfFreeClusters,TotalNumberOfClusters) then
Result:=GetDiskFreeSpaceEx(FullPath,FreeSize,FullSize,nil) else
Result:=false; end else
Result:=false;
end;
//=============================================================================>
//================================== TMyDrives ================================>
//=============================================================================>
constructor TMyDrives.Create;
begin // Конструктор >
inherited Create;
MyType:=mnDrives;
end;
  // Деструктор >
destructor TMyDrives.Destroy;
begin
inherited Destroy;
end;
  // Обновить >
function TMyDrives.UpDate: Boolean;
var a1:Cardinal; a2:TMyDrivesSet;
begin // Имя\Метка\Название\ >
if ClearDestroyAll then begin
Cardinal(a2):=GetLogicalDrives;
for a1:=Zero to mnMaxDrive do
if a1 in a2 then
Add(TMyDrive.Create(Char(Ord(mnFirstDriveChar)+a1)));
Result:=Count > Zero; end else
Result:=false;
end;
//=============================================================================>
//=============================== TMyApplication ==============================>
//=============================================================================>
constructor TMyApplication.Create(Protection: Boolean);
var a1,a2:Cardinal; s1,s2:String; f1:TMyFileStream; PI:TProcessInformation; SI:TStartupInfo;
begin // Конструктор >
inherited Create; // Наследование >
MyType:=mnApplication; // Тип = "приложение" >
mExeName:=GetExeName; // Полное имя (полны адрес) запущенного экзешника, в котором этот класс был создан >
mName:=ExtractFileNameOnly(mExeName); // Только имя (без расширения и адреса) программы >
mFileTrash:=TMyFileTrash.Create(mnTrashDir,Self); // Подготовка папки для сортировки разных вспомогательных\необходимых\дополнительных\закачанных файлов >
mLog:=TMyLog.Create(mFileTrash,mnLogPath); // Инициализация системного журнала >
mLog.LoadFromTextFile(mFileTrash.FilePath(mnLogLines)); // mLog.ClearLog;
mLog.WriteLog(mnl_SKIP_5,mnl_Start,mName); // Имя данного приложения >
mStringList:=TMyStringList.Create; // Создать строчный список, для разных утилитарных нужд >
mProcList:=TMyProcessList.Create(Self); // Список процессов >
Add(mProcList);
if Protection then begin
s1:=mFileTrash.FilePath(mName+mnDot+mnBUC);
if FileExists(s1) then begin
f1:=TMyFileStream.Create;
if f1.OpenRead(mExeName) then begin
if mStringList.OpenRead(s1) then
a1:=mStringList.SimilarTo(f1,Ten*mnKB) else
a1:=mError;
mStringList.Close; end else
a1:=mError;
f1.Destroy;
if a1 = mFalse then begin
mLog.WriteLog(mnl_EXE_FILE_CORUPTED);
s2:=mFileTrash.FilePath(mName+mnDot+mnVIRE);
mLog.WriteLog(mnl_EXE_MOVED_TO_VIRE,s2,CopyFile(PChar(mExeName),PChar(s2),false));
s2:=mFileTrash.mExePath+mName+'H'+mnDot+mnEXE; // Начало алгоритма перезапуска программы из резервной копии >
a2:=SizeOf(SI);
if CopyFile(PChar(mFileTrash.FilePath(mName+'H'+mnDot+mnBUC)),PChar(s2),false) then begin // Выколупываем из свалки программу, которая выколупает основную >
FillWithZero(@SI,a2);
SI.cb:=a2;
mLog.WriteLog(mnl_LUNCHING_REPAIR_PROGRAM,CreateProcess(nil,PChar(s2),nil,nil,false,Zero,nil,nil,SI,PI)); end; // Запускаем восстановителя >
s2:=mName+mnDot+mnBAT; // Создать BAT-файл с заданием: уничтожить программу, его создавшую >
if mStringList.OpenWrite(s2) then begin // создаём бат-файл в директории приложения >
mStringList.WriteLn(':try'); // Это метка с которой начинается >
mStringList.WriteLn('del "'+mExeName+'"'); // удаление по адресу >
mStringList.WriteLn('if exist "'+mExeName+'"'+' goto try'); // если все еще этот адрес доступен >
mStringList.WriteLn('del "'+s2+'"'); // возвращаемся к метке >
mStringList.Close;
FillWithZero(@SI,a2);
SI.dwFlags:=STARTF_USESHOWWINDOW;
SI.wShowWindow:=SW_HIDE;
mLog.WriteLog(mnl_BAT_SELF_ERASE,CreateProcess(nil,PChar(s2),nil,nil,False,IDLE_PRIORITY_CLASS,nil,nil,SI,PI)); end else // Включаем рубатель "втихушку" >
mLog.WriteLog(mnl_BAT_SELF_ERASE,false);
mLog.WriteLog(mnl_SELF_PROCESS_DESTRUCTION,mProcList.TerminateSelf); end; end else
mLog.WriteLog(mnl_SELF_BUC_CREATION,CopyFile(PChar(mExeName),PChar(s1),false)); end; // Создать резервную копию >
mCPU:=TMyCPU.Create; // Процессор >
mLog.WriteLog(mnl_CPU_SPEED,Round(mCPU.CPUSpeed));
Add(mCPU);
mRAM:=TMyRam.Create; // Данные об оперативной памяти >
mLog.WriteLog(mnl_RAM_TOTAL,mRAM.TotalPhysical);
mLog.WriteLog(mnl_RAM_USED,mRAM.UsedPhysical);
mLog.WriteLog(mnl_RAM_FREE,mRAM.FreePhysical);
Add(mRAM);
mWindows:=TMyWindows.Create; // Windows >
mLog.WriteLog(mnl_WINDOWS_NAME,mWindows.CSDVersion);
mLog.WriteLog(mnl_WINDOWS_DIRECTORY,mWindows.NucleusName);
mLog.WriteLog(mnl_PLATFORM_ID,mWindows.PlatformId);
Add(mWindows);
mDrives:=TMyDrives.Create;
Add(mDrives);
mComputerName:=GetWindowsComputerName; // Имя компа под виндой >
mLog.WriteLog(mnl_COMPUTER_WINDOWS_NAME,mComputerName); // Название компа в виндовсе >
mUDB:=TMyUDB.Create(Self); // Подключение "гиперпамяти" >
if mUDB.Open(mnHyperMem) then // Попытаться открыть >
mLog.WriteLog(mnl_UDB_OPEN,mnHyperMem,true) else // Получилось... >
mLog.WriteLog(mnl_UDB_CREATE,mnHyperMem,mUDB.Build(mnHyperMem)); // Попробуем пересоздать >
if mUDB.Opened then begin // Пишем отчёт в лог >
mLog.WriteLog(mnl_UDB_TREE_COUNT,mUDB.Tree.Count);
mLog.WriteLog(mnl_UDB_TREE_SIZE,mUDB.Tree.Size);
mLog.WriteLog(mnl_UDB_LINKS_COUNT,mUDB.Links.Count);
mLog.WriteLog(mnl_UDB_LINKS_SIZE,mUDB.Links.Size);
mLog.WriteLog(mnl_UDB_PARAMS_COUNT,mUDB.Params.Count);
mLog.WriteLog(mnl_UDB_PARAMS_SIZE,mUDB.Params.Size); end;
mNodeExplorer:=TMyNodeExplorer.Create(Self); // Обозреватель узлов >
mLog.WriteLog(mnl_USERER_WINDOWS_NAME,mNodeExplorer.Name); // Имя пользователя, под которым запущена данная копия программы >
mLog.WriteLog(mnl_EXPLORER_INIT_COMPLETE); // Навигатор по компу >
end;
  // Деструктор >
destructor TMyApplication.Destroy;
begin
mProcList.Destroy;
mDrives.Destroy;
mWindows.Destroy;
mRAM.Destroy;
mCPU.Destroy;
mNodeExplorer.Destroy;
mUDB.Destroy;
mStringList.Destroy;
Log.WriteLog(mnl_SKIP_5,mnl_End,mName); // Конец работы данного приложения >
mLog.Destroy;
mFileTrash.Destroy;
inherited Destroy;
end;
  // Обновить >
function TMyApplication.UpDate: Boolean;
begin
Result:=mRAM.UpDate and mDrives.UpDate and mProcList.UpDate;
end;
  // Остановка программы "старым способом" >
procedure TMyApplication.HaltM;
begin
Halt(Zero);
end;
//=============================================================================>
//================================= Конец модуля ==============================>
//=============================================================================>
end.
