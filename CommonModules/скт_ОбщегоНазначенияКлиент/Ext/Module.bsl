﻿#Область ПрограммныйИнтерфейс

// Функция - Проверить и запустить толстый клиент
//		P.S. должна быть активна доменная авторизация
//
// Параметры:
//  ЭтотОбъект	 - ФормаКлиентскогоПриложения - Форма, с которой происходит открытие толстого клиента
//		Если параметр был передан, то будет попытка получения навигационной ссылки формы и открытие её в толстом клиенте
// 
// Возвращаемое значение:
//  Булево - Признак - удалось ли запустить клиент
//
Функция ПроверитьЗапуститьТолстыйКлиент(ЭтотОбъект = Неопределено) Экспорт 
	
	#Если ТолстыйКлиентОбычноеПриложение ИЛИ ТолстыйКлиентУправляемоеПриложение Тогда
		Возврат Ложь;
	#КонецЕсли
	
	#Если Клиент  Тогда 
		ПоказатьОповещениеПользователя(
		НСтр("ru = 'Запуск толстого клиента';
			|bg = 'Стартиранее на голям клиент';
			|en = 'Start thick client'"), , 
		НСтр("ru = 'Функция доступна только в толстом клиенте. Поэтому запускается толстый клиент.';
		|bg = 'Функцията е достъпна само в дебел клиент. Ето защо се стартира дебел клиент.';
		|en = 'This feature is only available in the thick client, therefore the thick client will be launched now.'"), 
		БиблиотекаКартинок.Информация);
	#КонецЕсли
		
	НавигационнаяСсылка = Неопределено;
	Если ЭтотОбъект <> Неопределено Тогда
		НавигационнаяСсылка = ЭтотОбъект.НавигационнаяСсылка;
		Если Не ЗначениеЗаполнено(НавигационнаяСсылка) Тогда
			Попытка
				СсылкаОбъекта = ЭтотОбъект.Объект.Ссылка;
				ФормаОбъекта = ЭтотОбъект;
			Исключение
				// ничего не делаем
			КонецПопытки;
			Если СсылкаОбъекта = Неопределено Тогда
				Попытка
					СсылкаОбъекта = ЭтотОбъект.ВладелецФормы.Объект.Ссылка;
					ФормаОбъекта = ЭтотОбъект;
				Исключение
					// ничего не делаем
				КонецПопытки;
			КонецЕсли; 
			Если ФормаОбъекта <> Неопределено Тогда
				Если Не ЗначениеЗаполнено(СсылкаОбъекта) Или ЭтотОбъект.Модифицированность Тогда
					Если Не ФормаОбъекта.Записать() Тогда 
						Возврат Ложь;
					КонецЕсли; 
				КонецЕсли; 
				НавигационнаяСсылка = ПолучитьНавигационнуюСсылку(СсылкаОбъекта);
			КонецЕсли; 
		КонецЕсли; 
	КонецЕсли; 
	ЗапуститьКлиент( , , , , НавигационнаяСсылка);
	Возврат Истина;

КонецФункции

// Процедура - Запустить клиент
//
// Параметры:
//  ТипКлиента		 - Строка - Тип клиента, который надо открыть: ТолстыйКлиентУправляемоеПриложение, 
//				ТолстыйКлиентОбычноеПриложение и тд.
//  КаталогПрограммы - Строка - Расположение exe файлов, для запуска клиента
//  Пользователь	 - Строка - Логин
//  Пароль			 - Строка - Пароль для авторизации в системе
//  URL				 - Строка - Навигационная ссылка, которая будет открыта
//  ПараметрыЗапуска - Строка - Дополнительные произвольные параметры запуска
//
Процедура ЗапуститьКлиент(ТипКлиента = "ТолстыйКлиентУправляемоеПриложение", Знач КаталогПрограммы = Неопределено, Пользователь = Неопределено, Пароль = Неопределено, 
	URL = Неопределено, ПараметрыЗапуска = Неопределено) Экспорт 
	
	#Если НЕ ВебКлиент Тогда
	СтрокаПараметров = " ENTERPRISE /IBConnectionString " + СтрокаСоединенияИнформационнойБазы() + " /AppAutoCheckVersion /DisableStartupMessages";	
	Если ТипКлиента = "ТолстыйКлиентУправляемоеПриложение" ИЛИ ТипКлиента = "ТонкийКлиент" Тогда 
		СтрокаПараметров = СтрокаПараметров + " /RunModeManagedApplication";
	ИначеЕсли ТипКлиента = "ТолстыйКлиентОбычноеПриложение" Тогда 
		СтрокаПараметров = СтрокаПараметров + " /RunModeOrdinaryApplication";
	Иначе	
		СтрокаПараметров = СтрокаПараметров + " /AppAutoCheckMode";
	КонецЕсли;	
	
	Если КаталогПрограммы = Неопределено Тогда 
		ПутьКПриложению = КаталогПрограммы();
	Иначе
		ПутьКПриложению = КаталогПрограммы;
	КонецЕсли;	
	Если ТипКлиента = "ТонкийКлиент" Тогда 
		ПутьКПриложению = ПутьКПриложению + "1cv8c";
	Иначе	
		ПутьКПриложению = ПутьКПриложению + "1cv8";
	КонецЕсли;	
	
	Если Пользователь <> Неопределено Тогда 
		СтрокаПараметров = СтрокаПараметров + " /N """ + Пользователь + """";
		Если Пароль <> Неопределено Тогда 
			СтрокаПараметров = СтрокаПараметров + " /P """ + Пароль + """ /DisableStartupDialogs";
		КонецЕсли;
	Иначе	
		СтрокаПараметров = СтрокаПараметров + " /N """ + ИмяПользователя() + """";
	КонецЕсли;	
	
	Если URL <> Неопределено Тогда 
		СтрокаПараметров = СтрокаПараметров + " /URL """ + URL + """";
	КонецЕсли;	
	
	Если ПараметрыЗапуска <> Неопределено Тогда 
		СтрокаПараметров = СтрокаПараметров + " /C """ + ПараметрыЗапуска + """";
	КонецЕсли;	
		
	СистемнаяИнформация = Новый СистемнаяИнформация;
	Если СистемнаяИнформация.ТипПлатформы = ТипПлатформы.Windows_x86 
		ИЛИ СистемнаяИнформация.ТипПлатформы = ТипПлатформы.Windows_x86_64 Тогда 
		ЗапуститьПриложениеАсинх("""" + ПутьКПриложению + ".exe""" + СтрокаПараметров);
	Иначе	
		ЗапуститьПриложениеАсинх(ПутьКПриложению + СтрокаПараметров);
	КонецЕсли;	
	#Иначе
	Сообщить("Запуск толстого клиента невозможен из web клиента.");
	#КонецЕсли

КонецПроцедуры

#КонецОбласти
