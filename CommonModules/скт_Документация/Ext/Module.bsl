﻿
#Область ПрограммныйИнтерфейс

Функция OpenAPI() Экспорт 

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
		Аргументы = АргументыМетодов.НайтиСтроки(Новый Структура("Ссылка", ВыборкаМетодов.Ссылка));
		Если Аргументы.Количество() Тогда 
			АргументыОписание = Новый Массив;
			Для Каждого текАргумент Из Аргументы Цикл
				ОписаниеАргумента = Новый Соответствие;
				ОписаниеАргумента.Вставить("name", текАргумент.Имя);
				ОписаниеАргумента.Вставить("required", текАргумент.Обязательный);
				ОписаниеАргумента.Вставить("in", "query");
				ОписаниеАргумента.Вставить("schema", Новый Структура("type", "string"));
				АргументыОписание.Добавить(ОписаниеАргумента);
			КонецЦикла;
			ОписаниеЭндПоинта.Вставить("parameters", АргументыОписание);
		КонецЕсли;
		
		ОписаниеМетода = Новый Соответствие;
		ОписаниеМетода.Вставить("description", ВыборкаМетодов.Наименование);
		Если Не ПустаяСтрока(ВыборкаМетодов.ОписаниеМетода) Тогда
			ОписаниеМетода.Вставить("summary", ВыборкаМетодов.ОписаниеМетода);
		КонецЕсли;
		ОписаниеЭндПоинта.Вставить("get", ОписаниеМетода);
		
		Описание["paths"].Вставить(Метод, ОписаниеЭндПоинта);
	КонецЦикла;
	
	Запись = Новый ЗаписьJSON;
	Запись.УстановитьСтроку();
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
	
	ИнформацияОбAPI = Новый Соответствие;
	ИнформацияОбAPI.Вставить("title", Метаданные.Представление());
	ИнформацияОбAPI.Вставить("description", "Сервис получения данных из 1С Предприятия.");
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


#КонецОбласти