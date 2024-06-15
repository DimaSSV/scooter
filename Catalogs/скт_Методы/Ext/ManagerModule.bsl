﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ПрограммныйИнтерфейс

Функция НовыеАргументыВызоваМетода(МетодСсылка) Экспорт

	Результат = Новый Структура;
	Результат.Вставить("Формат", 			МетодСсылка.Формат);
	Результат.Вставить("Архивировать", 		МетодСсылка.Архивировать);
	Результат.Вставить("СпособДоставки", 	МетодСсылка.СпособДоставки);
	Результат.Вставить("ПутьДляВыгрузки", 	МетодСсылка.ПутьДляВыгрузки);
	Возврат Результат;

КонецФункции // НовыеАргументыВызоваМетода()

Процедура Вызвать(Метод, ПотокПриемник, Знач ВходныеПараметры = Неопределено, выхРасширениеФайла = Неопределено) Экспорт 

	Если ВходныеПараметры = Неопределено Тогда
		ВходныеПараметры = Новый Структура;
	КонецЕсли;
	Аргументы = НовыеАргументыВызоваМетода(Метод);
	Если ВходныеПараметры.Свойство("Формат") Тогда 
		Формат = ВходныеПараметры.Формат;
		Если ТипЗнч(Формат) = Тип("Строка") Тогда
			Формат = Перечисления.скт_ВариантыФорматовВыгрузки.ПоИмени(Формат);
		КонецЕсли;
		Если Формат <> Неопределено Тогда
			Аргументы.Формат = Формат;
		КонецЕсли;
		ВходныеПараметры.Удалить("Формат");
	КонецЕсли;
	Если ВходныеПараметры.Свойство("Архивировать") Тогда
		Архивировать = ВходныеПараметры.Архивировать;
		Если ТипЗнч(Архивировать) <> Тип("Булево") Тогда
			Архивировать = НРег(Архивировать) = "true" Или Архивировать = "1";
		КонецЕсли;
		Аргументы.Архивировать = Архивировать;
		ВходныеПараметры.Удалить("Архивировать");
	КонецЕсли;
	Если ВходныеПараметры.Свойство("СпособДоставки") Тогда
		СпособДоставки = ВходныеПараметры.СпособДоставки;
		Если ТипЗнч(СпособДоставки) = Тип("Строка") Тогда
			СпособДоставки = ?(СпособДоставки = "1", Перечисления.скт_СпособыДоставкиРезультата.ВыгрузкаВКаталог, Перечисления.скт_СпособыДоставкиРезультата.Непосредственно);
		КонецЕсли;
		Аргументы.СпособДоставки = СпособДоставки;
		ВходныеПараметры.Удалить("СпособДоставки");
	КонецЕсли;
	Если ВходныеПараметры.Свойство("ПутьДляВыгрузки") Тогда
		Аргументы.ПутьДляВыгрузки = ВходныеПараметры.ПутьДляВыгрузки;
		ВходныеПараметры.Удалить("ПутьДляВыгрузки");
	КонецЕсли;
	
	Для Каждого текПараметр Из ВходныеПараметры Цикл
		Если текПараметр.Значение <> Неопределено Тогда
			Аргументы.Вставить(текПараметр.Ключ, текПараметр.Значение);
		КонецЕсли;
	КонецЦикла;
	
	Логировать = ПланыВидовХарактеристик.скт_ДополнительныеНастройки.ПрочитатьЗначение("скт_ЛогироватьВызовыМетодов");
	Если Логировать Тогда
		ЗалогироватьНачалоВызова(Метод, Аргументы);
	КонецЕсли;
	
	ИмяМетода = Метод.Код;
	Если Аргументы.Архивировать Тогда
		РасширениеФайла = "zip";
	Иначе
		РасширениеФайла = Перечисления.скт_ВариантыФорматовВыгрузки.РасширениеФайлаДляСохранения(Аргументы.Формат);
	КонецЕсли;
	
	РезультатКомпоновки = ПолучитьРезультатКомпоновки(Метод, Аргументы);
	
	Если Аргументы.СпособДоставки = Перечисления.скт_СпособыДоставкиРезультата.Непосредственно Тогда
		ВывестиРезультатВыполненияПоФормату(РезультатКомпоновки, ИмяМетода, Аргументы.Формат, ПотокПриемник, Аргументы.Архивировать);
		выхРасширениеФайла = РасширениеФайла;
	Иначе
		ПутьДляВыгрузки = Метод.ПутьДляВыгрузки;
		ИмяФайлаВыгрузки = ИмяМетода;
		ФайлВыгрузки = Новый Файл(ПутьДляВыгрузки + ИмяФайлаВыгрузки + "." + РасширениеФайла);
		Поток = Новый ФайловыйПоток(ФайлВыгрузки.ПолноеИмя
		, РежимОткрытияФайла.Создать, ДоступКФайлу.Запись);
		ВывестиРезультатВыполненияПоФормату(РезультатКомпоновки, ИмяМетода, Аргументы.Формат, Поток, Аргументы.Архивировать);
		
		Запись = Новый ЗаписьТекста(ПотокПриемник, КодировкаТекста.UTF8, Символы.ПС, Символы.ПС, Ложь);
		Запись.ЗаписатьСтроку(СтрШаблон("Результат записан в файл: %1", СокрЛП(ФайлВыгрузки.ПолноеИмя)));
		Запись.Закрыть();
		выхРасширениеФайла = "txt";
	КонецЕсли;
	
	Если Логировать Тогда
		ЗалогироватьОкончаниеВызова(Метод, РезультатКомпоновки, РасширениеФайла);
	КонецЕсли;
	
КонецПроцедуры // Вызвать()

Функция ПолучитьРезультатКомпоновки(Метод, ВходныеПараметры = Неопределено) Экспорт

	Если ВходныеПараметры = Неопределено Тогда
		ВходныеПараметры = Новый Структура;
	КонецЕсли;
	
	АргументыМетода = Метод.Аргументы;
	ОбязательныеАргументы = АргументыМетода.НайтиСтроки(Новый Структура("Обязательный", Истина));
	Для Каждого текАргумент Из ОбязательныеАргументы Цикл
		Если Не ВходныеПараметры.Свойство(текАргумент.Имя) Тогда
			ВызватьИсключение СтрШаблон("В метод ""%1"" не передан обязательный аргумент ""%2""", Метод.Код, текАргумент.Имя);
		КонецЕсли;             
	КонецЦикла;
	
	Источник = Метод.Источник; 
	Схема = Источник.Схема.Получить();
	Компоновщик = Справочники.скт_Источники.КомпоновщикНастроек(Источник, Метод.ПользовательскиеНастройки.Получить());
	
	ТаблицаАргументов = АргументыМетода.Выгрузить();
	ТаблицаАргументов.Колонки.Добавить("Значение", Новый ОписаниеТипов);
	
	// Конвертация аргументов
	Для Каждого текАргумент Из ТаблицаАргументов Цикл
		
		// Пропустим, если значение аргумента не передали
		Если Не ВходныеПараметры.Свойство(текАргумент.Имя) Тогда
			Продолжить;
		КонецЕсли;
		
		Если текАргумент.Конвертация.Пустая() Тогда
			текАргумент.Значение = ВходныеПараметры[текАргумент.Имя];
		Иначе
			Алгоритм = скт_ПроизвольныеАлгоритмыСервер.ОбъектВнешнейОбработки(текАргумент.Конвертация);
			текАргумент.Значение = Алгоритм.ПолучитьРезультат(ВходныеПараметры[текАргумент.Имя], Метод, Схема, Компоновщик, текАргумент);
		КонецЕсли;
		
	КонецЦикла;
	
	// сначала попробуем присвоить параметры по имени аргументов.
	Для Каждого текАргумент Из ТаблицаАргументов Цикл
		
		// Пропустим, если значение аргумента не передали
		Если Не ВходныеПараметры.Свойство(текАргумент.Имя) Тогда
			Продолжить;
		КонецЕсли;
		
		Если Не ПустаяСтрока(текАргумент.ИдентификаторНастройки) Тогда
			Продолжить;
		КонецЕсли;
		
		ПараметрКомпоновки = Новый ПараметрКомпоновкиДанных(текАргумент.Имя);
		СтрокаПараметра = Компоновщик.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(ПараметрКомпоновки);
		Если СтрокаПараметра <> Неопределено Тогда
			Если Не ПустаяСтрока(СтрокаПараметра.ИдентификаторПользовательскойНастройки) Тогда
				ПользовательскайНастройка = Компоновщик.ПользовательскиеНастройки.Элементы.Найти(СтрокаПараметра.ИдентификаторПользовательскойНастройки);
				Если ПользовательскайНастройка <> Неопределено Тогда
					СтрокаПараметра = ПользовательскайНастройка;
				КонецЕсли;
			КонецЕсли;
			СтрокаПараметра.Использование = Истина;
			СтрокаПараметра.Значение = текАргумент.Значение;
		КонецЕсли;
	КонецЦикла;
		
	// Теперь переопределим аргументы по явному мэппинту на пользовательскую настройку
	Для Каждого текАргумент Из ТаблицаАргументов Цикл
		
		// Пропустим, если значение аргумента не передали
		Если Не ВходныеПараметры.Свойство(текАргумент.Имя) Тогда
			Продолжить;
		КонецЕсли;
		
		Если ПустаяСтрока(текАргумент.ИдентификаторНастройки) Тогда
			Продолжить;
		КонецЕсли;
		
		ИдентификаторНастройки = ИдентификаторКомпоновкиИзСтроки(текАргумент.ИдентификаторНастройки);
		Настройка = Компоновщик.ПользовательскиеНастройки.ПолучитьОбъектПоИдентификатору(ИдентификаторНастройки);
		ТипНастройки = ТипЗнч(Настройка);
		Если ТипНастройки = Тип("ЭлементОтбораКомпоновкиДанных") Тогда
			Настройка.Использование = Истина;
			Настройка.ПравоеЗначение = текАргумент.Значение;
		ИначеЕсли ТипНастройки = Тип("ЗначениеПараметраНастроекКомпоновкиДанных") Тогда
			Настройка.Использование = Истина;
			Настройка.Значение = текАргумент.Значение;
		КонецЕсли;
		
	КонецЦикла;
	
	ВнешниеНаборыДанных = Неопределено;
	
	Для Каждого текАлгоритм Из Метод.Подготовка.НайтиСтроки(Новый Структура("Активность", Истина)) Цикл
		Алгоритм = скт_ПроизвольныеАлгоритмыСервер.ОбъектВнешнейОбработки(текАлгоритм.Алгоритм);
		Алгоритм.ВыполнитьПодготовкуМетода(Метод, Схема, Компоновщик, ТаблицаАргументов, ВходныеПараметры, ВнешниеНаборыДанных);
	КонецЦикла;
	
	Приемник = Новый ТабличныйДокумент;
	Если ВходныеПараметры.Формат = Перечисления.скт_ВариантыФорматовВыгрузки.CSV 
		Или ВходныеПараметры.Формат = Перечисления.скт_ВариантыФорматовВыгрузки.JSON
		Или ВходныеПараметры.Формат = Перечисления.скт_ВариантыФорматовВыгрузки.XML Тогда
		Приемник = Новый ТаблицаЗначений;
	КонецЕсли;
	
	Возврат Справочники.скт_Источники.Скомпоновать(Источник
		, Компоновщик.ПолучитьНастройки(), Приемник, ВнешниеНаборыДанных);

КонецФункции // ПолучитьРезультат()

#КонецОбласти

#Область СлужебныеФункции

Процедура ВывестиРезультатВыполненияПоФормату(РезультатВыполнения, ИмяМетода, Формат, Поток, Архивировать)
	
	Если Архивировать Тогда
		ВременныйФайл = СтрШаблон("%1%2.%3", КаталогВременныхФайлов(), ИмяМетода, Перечисления.скт_ВариантыФорматовВыгрузки.РасширениеФайлаДляСохранения(Формат));
		ВремПоток = Новый ФайловыйПоток(ВременныйФайл
		, РежимОткрытияФайла.Создать, ДоступКФайлу.Запись);
		ВывестиРезультатВыполненияПоФормату(РезультатВыполнения, ИмяМетода, Формат, ВремПоток, Ложь);
		ВремПоток.Закрыть();
		
		Зип = Новый ЗаписьZipФайла(Поток,,,МетодСжатияZIP.Сжатие, УровеньСжатияZIP.Максимальный,, КодировкаИменФайловВZipФайле.UTF8);
		Зип.Добавить(ВременныйФайл, РежимСохраненияПутейZIP.СохранятьОтносительныеПути, РежимОбработкиПодкаталоговZIP.ОбрабатыватьРекурсивно);
		Зип.Записать();
		УдалитьФайлы(ВременныйФайл);
	Иначе
		Если Формат = Перечисления.скт_ВариантыФорматовВыгрузки.CSV Тогда
			скт_ОбщегоНазначенияСервер.CSVПоТаблицеЗначений(РезультатВыполнения, Поток);
		ИначеЕсли Формат = Перечисления.скт_ВариантыФорматовВыгрузки.JSON Тогда
			скт_ОбщегоНазначенияСервер.JSONПоТаблицеЗначений(РезультатВыполнения, Поток);
		ИначеЕсли Формат = Перечисления.скт_ВариантыФорматовВыгрузки.XML Тогда
			скт_ОбщегоНазначенияСервер.XMLПоТаблицеЗначений(РезультатВыполнения, Поток);
		Иначе
			скт_ОбщегоНазначенияСервер.ДвоичныеДанныеТабличногоДокумента(РезультатВыполнения, ТипФайлаТабличногоДокумента[XMLСтрока(Формат)], Поток);
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

Функция ИдентификаторКомпоновкиИзСтроки(Строка)

	Чтение = Новый ЧтениеXML;
	Чтение.УстановитьСтроку(Строка);
	Пакет = ФабрикаXDTO.Пакеты.Получить("http://v8.1c.ru/8.1/data-composition-system/core");
	Тип = Пакет.Получить("ID");
	XDTO = ФабрикаXDTO.ПрочитатьXML(Чтение, Тип);
	Возврат СериализаторXDTO.ПрочитатьXDTO(XDTO);

КонецФункции // ИдентификаторКомпоновкиИзСтроки()

Процедура ЗалогироватьНачалоВызова(Метод, Аргументы)

	ШаблонСообщения = 
	"Вызван метод ""%1"" со следующими аргументами:
	|
	|%2";
	
	МассивСообщенийАргументы = Новый Массив;
	Для Каждого текСтрока Из Аргументы Цикл
		МассивСообщенийАргументы.Добавить(СтрШаблон("%1: %2", текСтрока.Ключ, текСтрока.Значение));
	КонецЦикла;
	
	СообщениеДляЖурнала = СтрШаблон(ШаблонСообщения, Метод, СтрСоединить(МассивСообщенийАргументы, Символы.ПС));
	
	скт_ОбщегоНазначенияСервер.ЗаписатьВЖурнал("Начало вызова метода", СообщениеДляЖурнала, , Метод, Метод.Метаданные());
	
КонецПроцедуры

Процедура ЗалогироватьОкончаниеВызова(Метод, РезультатКомпоновки, РасширениеФайла)

	ШаблонСообщения = 
	"Получен результат метода %1:
	|
	|%2
	|
	|Результат выгружен в файл %3";
	
	Если ТипЗнч(РезультатКомпоновки) = Тип("ТаблицаЗначений") Тогда
		текстРезультат = СтрШаблон("Таблица значении, количество колонок %1, количество строк выборки %2", РезультатКомпоновки.Колонки.Количество(), РезультатКомпоновки.Количество());
	Иначе
		текстРезультат = СтрШаблон("Табличный документ, количество колонок %1, количество строк в документе %2", РезультатКомпоновки.ШиринаТаблицы, РезультатКомпоновки.ВысотаТаблицы);
	КонецЕсли;
	
	СообщениеДляЖурнала = СтрШаблон(ШаблонСообщения, Метод, текстРезультат, РасширениеФайла);
	
	скт_ОбщегоНазначенияСервер.ЗаписатьВЖурнал("Окончание вызова метода", СообщениеДляЖурнала, , Метод, Метод.Метаданные());

КонецПроцедуры

#КонецОбласти

#КонецЕсли