object dmDados: TdmDados
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 503
  Width = 700
  object FDConnection1: TFDConnection
    Params.Strings = (
      'User_Name=admin'
      'Password=a159357a'
      'Server=teste-delphi1.ccguhfztlkwf.us-east-1.rds.amazonaws.com'
      'Database=teste_delphi'
      'DriverID=MySQL')
    LoginPrompt = False
    Left = 96
    Top = 16
  end
  object FDPhysMySQLDriverLink1: TFDPhysMySQLDriverLink
    VendorLib = 'D:\Delphi\Projetos\Teste_Delphi\libmysql.dll'
    Left = 96
    Top = 72
  end
  object FDGUIxWaitCursor1: TFDGUIxWaitCursor
    Provider = 'Forms'
    Left = 96
    Top = 128
  end
  object FDQuery1: TFDQuery
    Connection = FDConnection1
    SQL.Strings = (
      'select * from CLIENTES order by NOME')
    Left = 232
    Top = 16
  end
end
