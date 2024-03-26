﻿
#Область ПрограммныйИнтерфейс

Функция OpenAPI() Экспорт 

	УстановитьПривилегированныйРежим(Истина);
	Описание = НовоеОписаниеOPENAPI();
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	скт_Методы.Код КАК Код,
	|	скт_Методы.Наименование КАК Наименование,
	|	скт_Методы.ОписаниеМетода КАК ОписаниеМетода,
	|	скт_Методы.Источник.Схема КАК Схема,
	|	скт_Методы.Источник.Настройки КАК Настройки,
	|	скт_Методы.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.скт_Методы КАК скт_Методы
	|ГДЕ
	|	скт_Методы.Активность
	|	И НЕ скт_Методы.ПометкаУдаления
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	скт_МетодыАргументы.Ссылка КАК Ссылка,
	|	скт_МетодыАргументы.Имя КАК Имя,
	|	скт_МетодыАргументы.Обязательный КАК Обязательный
	|ИЗ
	|	Справочник.скт_Методы.Аргументы КАК скт_МетодыАргументы
	|ГДЕ
	|	НЕ скт_МетодыАргументы.Ссылка.ПометкаУдаления
	|	И скт_МетодыАргументы.Ссылка.Активность
	|
	|УПОРЯДОЧИТЬ ПО
	|	Ссылка";
	
	РезультатыЗапроса = Запрос.ВыполнитьПакет();
	ВыборкаМетодов = РезультатыЗапроса[0].Выбрать();
	АргументыМетодов = РезультатыЗапроса[1].Выгрузить();
	Пока ВыборкаМетодов.Следующий() Цикл
		Метод = СтрШаблон("/%1", ВыборкаМетодов.Код);
		
		ОписаниеЭндПоинта = Новый Соответствие;
		АргументыОписание = АргументыОписание();
		Аргументы = АргументыМетодов.НайтиСтроки(Новый Структура("Ссылка", ВыборкаМетодов.Ссылка));
		Для Каждого текАргумент Из Аргументы Цикл
			ОписаниеАргумента = Новый Соответствие;
			ОписаниеАргумента.Вставить("name", текАргумент.Имя);
			ОписаниеАргумента.Вставить("required", текАргумент.Обязательный);
			ОписаниеАргумента.Вставить("in", "query");
			ОписаниеАргумента.Вставить("schema", Новый Структура("type", "string"));
			АргументыОписание.Добавить(ОписаниеАргумента);
		КонецЦикла;
		ОписаниеЭндПоинта.Вставить("parameters", АргументыОписание);
		
		ОписаниеМетода = Новый Соответствие;
		ОписаниеМетода.Вставить("summary", ВыборкаМетодов.Наименование);
		Если Не ПустаяСтрока(ВыборкаМетодов.ОписаниеМетода) Тогда
			ОписаниеМетода.Вставить("description", ВыборкаМетодов.ОписаниеМетода);
		КонецЕсли;
		ОписаниеЭндПоинта.Вставить("get", ОписаниеМетода);
		
		Описание["paths"].Вставить(Метод, ОписаниеЭндПоинта);
	КонецЦикла;
	
	Запись = Новый ЗаписьJSON;
	Запись.УстановитьСтроку(Новый ПараметрыЗаписиJSON(ПереносСтрокJSON.Нет));
	ЗаписатьJSON(Запись, Описание);
	Возврат Запись.Закрыть();

КонецФункции // OpenAPI()

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс
// Код процедур и функций
#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция НовоеОписаниеOPENAPI(Версия = "3.1.0")

	Расширения = РасширенияКонфигурации.Получить(Новый Структура("Имя", "Самокат"), ИсточникРасширенийКонфигурации.СеансАктивные);
	Если Не Расширения.Количество() Тогда
		ВызватьИсключение "Расширение ""Самокат"" не найдено среди активных. Возможно изменилась реализация, обратитесь к поставщику.";
	КонецЕсли;
	ДанныеРасширения = Расширения.Получить(0);
	МетаданныеКонфигурации = Метаданные;
	МетаданныеСервиса = МетаданныеКонфигурации.HTTPСервисы.скт_Scooter;
	
	Результат = Новый Соответствие;
	Результат.Вставить("openapi", Версия);
	Результат.Вставить("components", ОбщиеКомпоненты());
	
	МассивБезопасность = Новый Массив;
	МассивБезопасность.Добавить(Новый Структура("basicAuth", Новый Массив));
	Результат.Вставить("security", МассивБезопасность);
	
	ИнформацияОбAPI = Новый Соответствие;
	ИнформацияОбAPI.Вставить("title", Метаданные.Представление());
	ИнформацияОбAPI.Вставить("summary", "Сервис получения данных из 1С Предприятия.");
	ИнформацияОбAPI.Вставить("description", 
	"Данное API позволяет получать произвольные данные из системы 1С. Методы добавляются динамически и после настройки сразу становятся доступны.
	|Во всех методах есть возможность поменять формат возвращаемого значения. Для этого к названию метода необходимо добавить расширение через "".""
	|Пример: ""Warehouses.xml"",""Warehouses.json"",""Warehouses.pdf"". Доступны следующие форматы:
	|- ANSITXT
	|- CSV
	|- DOCX
	|- JSON
	|- MXL
	|- MXL7
	|- ODS
	|- PDF
	|- TXT
	|- XLSX
	|- XML
	|
	|Также во всех методах доступны следующие параметры:
	|- unloadingtype - Способ доставки результата запроса. Если в значение передать 1, то результат будет выгружен в файл, если 0, то результат будет передан непосредственно в теле ответа на http запрос
	|- unloadingpath - Путь куда необходимо сохранить результат запроса, при способе доставки в каталог
	|- compressed - Архивировать. Если установить в true, то результат будет упакован в zip архив.");
	ИнформацияОбAPI.Вставить("version", ДанныеРасширения.Версия);
	Результат.Вставить("info", ИнформацияОбAPI);
	
	АдресПубликации = ПланыВидовХарактеристик.скт_ДополнительныеНастройки.ПрочитатьЗначение(ПланыВидовХарактеристик.скт_ДополнительныеНастройки.скт_АдресПубликацииБазы, "");
	Если Не ПустаяСтрока(АдресПубликации) Тогда
		УзелСервера = Новый Массив; 
		Сервер = Новый Соответствие;
		Сервер.Вставить("url", СтрШаблон("%1/hs/%2/%3", АдресПубликации, МетаданныеСервиса.КорневойURL, "Download"));
		УзелСервера.Добавить(Сервер);
		Результат.Вставить("servers", УзелСервера);
	КонецЕсли;
	
	Результат.Вставить("paths", Новый Соответствие);
	
	Возврат Результат;

КонецФункции // НовоеОписаниеOPENAPI()

Функция ОбщиеКомпоненты()

	ОбщиеКомпоненты = Новый Соответствие;
	ОбщиеКомпоненты.Вставить("securitySchemes", СхемыАвторизации());
	ОбщиеКомпоненты.Вставить("parameters", ОбщиеПараметры());
	Возврат ОбщиеКомпоненты;

КонецФункции // ОбщиеКомпоненты()

Функция СхемыАвторизации()

	СхемыАвторизации = Новый Соответствие;
	СхемыАвторизации.Вставить("basicAuth", СхемаАвторизацииБазовая());
	Возврат СхемыАвторизации;

КонецФункции // СхемыАвторизации()

Функция СхемаАвторизацииБазовая()

	СхемаБазовая = Новый Соответствие;
	СхемаБазовая.Вставить("type", "http");
	СхемаБазовая.Вставить("scheme", "basic");
	Возврат СхемаБазовая;

КонецФункции // СхемаАвторизацииБазовая()

Функция ОбщиеПараметры()

	ОбщиеПараметры = Новый Соответствие;
	ОбщиеПараметры.Вставить("unloadingtype", ПараметрСпособДоставки());
	ОбщиеПараметры.Вставить("unloadingpath", ПараметрПутьВыгрузки());
	ОбщиеПараметры.Вставить("compressed", ПараметрАрхивировать());
	Возврат ОбщиеПараметры;

КонецФункции // ОбщиеПараметры()

Функция ПараметрСпособДоставки()

	Параметр = Новый Соответствие;
	Параметр.Вставить("name", "unloadingtype");
	Параметр.Вставить("in", "query");
	Параметр.Вставить("description", "Способ доставки результата запроса. Если в значение передать 1, то результат будет выгружен в файл, если 0, то результат будет передан непосредственно в теле ответа на http запрос");
	Параметр.Вставить("schema", СхемаПростогоТипа("integer"));
	Возврат Параметр;

КонецФункции // ПараметрСпособДоставки()

Функция ПараметрПутьВыгрузки()

	Параметр = Новый Соответствие;
	Параметр.Вставить("name", "unloadingpath");
	Параметр.Вставить("in", "query");
	Параметр.Вставить("description", "Путь куда необходимо сохранить результат запроса, при способе доставки в каталог");
	Параметр.Вставить("schema", СхемаПростогоТипа("string"));
	Возврат Параметр;

КонецФункции // ПараметрПутьВыгрузки()

Функция ПараметрАрхивировать()

	Параметр = Новый Соответствие;
	Параметр.Вставить("name", "compressed");
	Параметр.Вставить("in", "query");
	Параметр.Вставить("description", "Архивировать. Если установить в true, то результат будет упакован в zip архив");
	Параметр.Вставить("schema", СхемаПростогоТипа("boolean"));
	Возврат Параметр;

КонецФункции // ПараметрПутьВыгрузки()

Функция АргументыОписание()

	Аргументы = Новый Массив;
	Аргументы.Добавить(НоваяСсылка("#/components/parameters/unloadingtype"));
	Аргументы.Добавить(НоваяСсылка("#/components/parameters/unloadingpath"));
	Аргументы.Добавить(НоваяСсылка("#/components/parameters/compressed"));
	Возврат Аргументы;

КонецФункции // АргументыОписание()

Функция НоваяСсылка(Путь)

	Ссылка = Новый Соответствие;
	Ссылка.Вставить("$ref", Путь);
	Возврат Ссылка;

КонецФункции // НоваяСсылка()

Функция СхемаПростогоТипа(Тип)

	Схема = Новый Соответствие;
	Типы = Новый Массив;
	Типы.Добавить(Тип);
	Схема.Вставить("type", Типы);
	Возврат Схема;

КонецФункции // СхемаПростогоТипа()

#КонецОбласти