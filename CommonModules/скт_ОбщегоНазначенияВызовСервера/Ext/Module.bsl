﻿
#Область ПрограммныйИнтерфейс

// Функция - Это валидный текст запроса
//
// Параметры:
//  ТекстЗапроса	 - Строка - текст запроса, который необходимо проверить
//  РежимКомпоновки	 - Булево - Если включено, то при проверке будет использован режим компоновки
//  Форматировать	 - Булево - при форматировании текста запроса коментарии будут удалены
//  текстОшибки		 - Строка - описание ошибки, при неудачной проверке текста запроса
// 
// Возвращаемое значение:
//  Булево - Результат проверки текста запроса
//
Функция ЭтоВалидныйТекстЗапроса(ТекстЗапроса, РежимКомпоновки = Истина, Форматировать = Ложь, текстОшибки = "") Экспорт 

	текстОшибки = "";
	Схема = Новый СхемаЗапроса;
	Схема.РежимКомпоновкиДанных = РежимКомпоновки;
	Попытка
		Схема.УстановитьТекстЗапроса(ТекстЗапроса);
		Если Форматировать Тогда
			ТекстЗапроса = Схема.ПолучитьТекстЗапроса();
		КонецЕсли;
		Возврат Истина;
	Исключение
		текстОшибки = КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
		Возврат Ложь;
	КонецПопытки;

КонецФункции // ЭтоВалидныйТекстЗапроса()

// Возвращает Истина, если функциональная подсистема существует в конфигурации.
// Предназначена для реализации вызова необязательной подсистемы (условного вызова).
// У функциональной подсистемы снят флажок "Включать в командный интерфейс".
// См. также ОбщегоНазначенияПереопределяемый.ПриОпределенииОтключенныхПодсистем
// и ОбщегоНазначенияКлиент.ПодсистемаСуществует для вызова из клиентского кода.
//
// Параметры:
//  ПолноеИмяПодсистемы - Строка - полное имя объекта метаданных подсистема
//                        без слов "Подсистема." и с учетом регистра символов.
//                        Например: "СтандартныеПодсистемы.ВариантыОтчетов".
//
// Пример:
//  Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ВариантыОтчетов") Тогда
//  	МодульВариантыОтчетов = ОбщегоНазначения.ОбщийМодуль("ВариантыОтчетов");
//  	МодульВариантыОтчетов.<Имя метода>();
//  КонецЕсли;
//
// Возвращаемое значение:
//  Булево - Истина, если подсистема существует.
//
Функция ПодсистемаСуществует(ПолноеИмяПодсистемы) Экспорт
	
	Возврат скт_ОбщегоНазначенияСервер.ПодсистемаСуществует(ПолноеИмяПодсистемы);
	
КонецФункции

Процедура ЗаписатьВЖурнал(вИмяСобытия, вКомментарий, вУровеньЖурнала = "Информация", 
	вДанные = Неопределено) Экспорт
	вМетаданные = Неопределено;
	Если вДанные <> Неопределено Тогда
		Попытка
			вМетаданные = вДанные.Метаданные();
		Исключение
		КонецПопытки;
	КонецЕсли;
	скт_ОбщегоНазначенияСервер.ЗаписатьВЖурнал(вИмяСобытия, вКомментарий, вУровеньЖурнала, вДанные, вМетаданные);
КонецПроцедуры

#КонецОбласти
