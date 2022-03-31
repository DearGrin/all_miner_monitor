class AvalonError{
  int id;
  String descr;
  AvalonError(this.id, this.descr);
}
class ErrorCodes {
  List<AvalonError> errorCodes = [
    AvalonError(131072, 'CODE_HUFAILED'),
    AvalonError(65536, 'CODE_INVALID_PLL_VALUE'),
    AvalonError(132768, 'CODE_PMUCRCFAILED'),
    AvalonError(16384, 'CODE_VCORE_ERR'),
    AvalonError(8192, 'CODE_VOL_ERR'),
    AvalonError(4096, 'CODE_NTC_ERR'),
    AvalonError(2048, 'CODE_PGFAILED'),
    AvalonError(1024, 'CODE_INVALIDPMU'),
    AvalonError(512, 'CODE_CORETESTFAILED'),
    AvalonError(256, 'CODE_LOOPFAILED'),
    AvalonError(128, 'CODE_HOTBEFORE'),
    AvalonError(64, 'CODE_TOOHOT'),
    AvalonError(32, 'CODE_RBOVERFLOW'),
    AvalonError(16, 'CODE_APIFIFOOVERFLOW'),
    AvalonError(8, 'CODE_LOCK'),
    AvalonError(4, 'CODE_NOFAN'),
    AvalonError(2, 'CODE_MMCRCFAILED'),
    AvalonError(1, 'CODE_IDLE'),
  ];
  List<AvalonError> psErrorCodes = [
    AvalonError(2048, 'FAN_error'),
    AvalonError(1024, 'OC_IOSC'),
    AvalonError(512, 'OC_IOSB'),
    AvalonError(256, 'OC_IOSA'),
    AvalonError(128, 'CS_error'),
    AvalonError(64, 'Output over current'),
    AvalonError(32, 'Output voltage low'),
    AvalonError(16, 'Input over current'),
    AvalonError(8, 'Over hot 3'),
    AvalonError(4, 'Over hot 2'),
    AvalonError(2, 'Over hot 1'),
    AvalonError(1, 'Input voltage low'),
    AvalonError(0, 'OK'),
  ];
}