﻿
#Область ОписаниеПеременных

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда 
		РежимОткрытияОкна = РежимОткрытияОкнаФормы.БлокироватьОкноВладельца;
	КонецЕсли;
	
	ПриСозданииПриЧтенииНаСервере(Параметры.ЗначениеКопирования);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	Если Не ЭтотОбъект.Параметры.Свойство("ТолькоПросмотр") Тогда
		ПриСозданииПриЧтенииНаСервере();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Если ТекущийОбъект.СпособДоставки = Перечисления.скт_СпособыДоставкиРезультата.ВыгрузкаВКаталог
		И Не ПустаяСтрока(ТекущийОбъект.ПутьДляВыгрузки) 
		И Не СтрЗаканчиваетсяНа(ТекущийОбъект.ПутьДляВыгрузки, ПолучитьРазделительПутиСервера())
		Тогда
		ТекущийОбъект.ПутьДляВыгрузки = ТекущийОбъект.ПутьДляВыгрузки + ПолучитьРазделительПутиСервера();
	КонецЕсли;
	СохранитьНастройки(ТекущийОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	АдресМетода = АдресМетода(АдресПубликации, ТекущийОбъект.Код);
	
КонецПроцедуры

&НаКлиенте
Процедура КомпоновщикПользовательскиеНастройкиНачалоПеретаскивания(Элемент, ПараметрыПеретаскивания, Выполнение)
	
	ДопустимыеТипы = Новый Массив;
	ДопустимыеТипы.Добавить(Тип("ЗначениеПараметраНастроекКомпоновкиДанных"));
	ДопустимыеТипы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	
	ЗначениеНастройки = Компоновщик.ПользовательскиеНастройки.ПолучитьОбъектПоИдентификатору(ПараметрыПеретаскивания.Значение);
	ТипНастройки = ТипЗнч(ЗначениеНастройки);
	Если ДопустимыеТипы.Найти(ТипНастройки) = Неопределено Тогда 
		Выполнение = Ложь;
		Возврат;
	КонецЕсли;
	
	ПараметрыПеретаскивания.Действие = ДействиеПеретаскивания.Копирование;
	
КонецПроцедуры

&НаКлиенте
Процедура АргументыПроверкаПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	
	Если Строка = Неопределено 
		Или ТипЗнч(ПараметрыПеретаскивания.Значение) <> Тип("ИдентификаторКомпоновкиДанных") Тогда 
		ПараметрыПеретаскивания.Действие = ДействиеПеретаскивания.Отмена;
		Возврат;
	КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
	ЗначениеНастройки = Компоновщик.ПользовательскиеНастройки.ПолучитьОбъектПоИдентификатору(ПараметрыПеретаскивания.Значение);
	
	СтрокаАргумента = Объект.Аргументы.НайтиПоИдентификатору(Строка);
	СтрокаАргумента.ИдентификаторНастройки = ИдентификаторНастройкиВСтроку(ПараметрыПеретаскивания.Значение);
	ОбработатьЗаполнениеСтрокиАргумента(СтрокаАргумента, Компоновщик);
	Модифицированность = Истина;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ИсточникПриИзменении(Элемент)
	ИсточникПриИзмененииСервер();		
КонецПроцедуры

&НаСервере
Процедура ИсточникПриИзмененииСервер()

	Схема = Объект.Источник.Схема.Получить();
	Настройки = Объект.Источник.Настройки.Получить();
	Если Настройки <> Неопределено Тогда
		Компоновщик.ЗагрузитьНастройки(Настройки);
	КонецЕсли;
	скт_КомпоновкаДанныхСервер.УстановитьСхемуКомпоновкиВФорме(ЭтотОбъект, Схема, АдресСхемы, Компоновщик);
	
КонецПроцедуры // ИсточникПриИзмененииСервер()

&НаКлиенте
Процедура СпособДоставкиПриИзменении(Элемент)
	НастроитьЭлементыФормы();
КонецПроцедуры

&НаКлиенте
Процедура ПутьДляВыгрузкиНачалоВыбора(Элемент, ДанныеВыбора, ВыборДобавлением, СтандартнаяОбработка)
	
	ПараметрыОткрытия = Новый Структура("ТекущийПуть, ВыборКаталога", Объект.ПутьДляВыгрузки, Истина);
	Обработчик = Новый ОписаниеОповещения("РезультатВыбораКаталогаВыгрузки", ЭтаФорма);
	ОткрытьФорму("ОбщаяФорма.скт_ФормаВыбораНаСервере", ПараметрыОткрытия, ЭтаФорма,,,,Обработчик);
	
КонецПроцедуры

&НаКлиенте
Процедура РезультатВыбораКаталогаВыгрузки(ПутьДляВыгрузки, ДопПараметры) Экспорт

	Если ПутьДляВыгрузки = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Объект.ПутьДляВыгрузки = ПутьДляВыгрузки;

КонецПроцедуры // РезультатВыбораКаталогаВыгрузки()

&НаКлиенте
Процедура АдресМетодаНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если СтрНачинаетсяС(НРег(АдресМетода), "http") Тогда
		ЗапуститьПриложениеАсинх(АдресМетода);
	Иначе
		УстановкаАдресаАсинх();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Асинх Процедура УстановкаАдресаАсинх()

	Рез = Ждать ВвестиСтрокуАсинх(АдресПубликации, "Введите адрес публикации базы на web сервере", 1024, Ложь);
	Если Рез <> Неопределено И АдресПубликации <> Рез Тогда
		АдресПубликации = Рез;
		СохранитьАдресПубликации(АдресПубликации);
		АдресМетода = АдресМетода(АдресПубликации, Объект.Код);
	КонецЕсли;

КонецПроцедуры // УстановкаАдресаАсинх()

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПроверитьДоступКПапке(Команда)
	ПроверитьДоступКПапкеНаСервере();
КонецПроцедуры

&НаСервере
Процедура ПроверитьДоступКПапкеНаСервере()
	Если ПустаяСтрока(Объект.ПутьДляВыгрузки) Тогда
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = "Не заполнен путь для выгрузки";
		Сообщение.Сообщить();
		Возврат;
	КонецЕсли;
	
	Если Не ФайлСуществует(Объект.ПутьДляВыгрузки) тогда
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = "Доступ к ресурсу отсутствует";
		Сообщение.Сообщить();
		Возврат;
	КонецЕсли;
	
	Попытка
		Текст = Новый ЗаписьТекста(
			Объект.ПутьДляВыгрузки + "\test.txt", // имя
			КодировкаТекста.ANSI, // кодировка
			Символы.ПС, // разделитель строк (необ.)
			Ложь // перезаписывать файл, а не дописывать в конец (необ.)
		);
		Текст.ЗаписатьСтроку("Тест");    
		Текст.Закрыть();
		УдалитьФайлы(Объект.ПутьДляВыгрузки + "\test.txt");
	Исключение
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = "Доступ к ресурсу отсутствует";
		Сообщение.Сообщить();
		Возврат;
	КонецПопытки;
	
	Сообщение = Новый СообщениеПользователю;
	Сообщение.Текст = "Есть доступ к ресурсу!";
	Сообщение.Сообщить();  
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПриСозданииПриЧтенииНаСервере(ПараметрКопирования = Неопределено)

	ЗагрузитьПараметрыОтборовНаСервере(ПараметрКопирования);
	АдресПубликации = ПланыВидовХарактеристик.скт_ДополнительныеНастройки.ПрочитатьЗначение(ПланыВидовХарактеристик.скт_ДополнительныеНастройки.скт_АдресПубликацииБазы, "");
	АдресМетода = АдресМетода(АдресПубликации, Объект.Код);
	Для Каждого текАргумент Из Объект.Аргументы Цикл
		ОбработатьЗаполнениеСтрокиАргумента(текАргумент, Компоновщик);
	КонецЦикла;
	НастроитьЭлементыФормы();

КонецПроцедуры // ПриСозданииПриЧтенииНаСервере()

&НаСервере
Процедура ЗагрузитьПараметрыОтборовНаСервере(ПараметрЗаполнения = Неопределено)

	Если ЗначениеЗаполнено(ПараметрЗаполнения) Тогда
		ДанныеЗаполнения = ПараметрЗаполнения;
	ИначеЕсли ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ДанныеЗаполнения = Объект.Ссылка;
	КонецЕсли;
	
	Если ДанныеЗаполнения <> Неопределено Тогда
		Схема = ДанныеЗаполнения.Источник.Схема.Получить();
	КонецЕсли;
	
	Если Схема = Неопределено Тогда
		Схема = Новый СхемаКомпоновкиДанных;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ДанныеЗаполнения) Тогда 
		Настройки = ДанныеЗаполнения.Источник.Настройки.Получить();
	КонецЕсли;
	Если Настройки = Неопределено Тогда
		Настройки = Схема.НастройкиПоУмолчанию;
	КонецЕсли;
	
	Компоновщик.ЗагрузитьНастройки(Настройки);
	
	Если ДанныеЗаполнения <> Неопределено Тогда
		ПользовательскиеНастройки = ДанныеЗаполнения.ПользовательскиеНастройки.Получить();
		Если ПользовательскиеНастройки <> Неопределено Тогда
			Компоновщик.ЗагрузитьПользовательскиеНастройки(ПользовательскиеНастройки);
		КонецЕсли;
	КонецЕсли;
	
	скт_КомпоновкаДанныхСервер.УстановитьСхемуКомпоновкиВФорме(ЭтотОбъект, Схема, АдресСхемы, Компоновщик);

КонецПроцедуры // ЗагрузитьПараметрыОтборовНаСервере()

&НаСервере
Функция ФайлСуществует(Знач ПутьКФайлу)
	Файл = Новый Файл(ПутьКФайлу);
	Возврат Файл.Существует();	
КонецФункции

&НаСервере
Процедура НастроитьЭлементыФормы()

	Элементы.ГруппаКаталог.Видимость = Объект.СпособДоставки = Перечисления.скт_СпособыДоставкиРезультата.ВыгрузкаВКаталог;	

КонецПроцедуры // НастроитьЭлементыФормы()

&НаСервере
Процедура СохранитьНастройки(ТекущийОбъект)

	ТекущийОбъект.ПользовательскиеНастройки = Новый ХранилищеЗначения(Компоновщик.ПользовательскиеНастройки);

КонецПроцедуры // СохранитьНастройки()

&НаСервереБезКонтекста
Функция АдресМетода(АдресПубликации, Имя)

	Если ЗначениеЗаполнено(АдресПубликации) И ЗначениеЗаполнено(Имя) Тогда
		МетаданныеСервиса = Метаданные.HTTPСервисы.скт_Scooter;
		Возврат СтрШаблон("%1/hs/%2/%3/%4", АдресПубликации, МетаданныеСервиса.КорневойURL, "Download", Имя);
	Иначе
		Возврат "<Не указан адрес публикации базы!>";
	КонецЕсли;

КонецФункции // АдресМетода()

&НаСервереБезКонтекста
Процедура СохранитьАдресПубликации(Адрес)

	ПланыВидовХарактеристик.скт_ДополнительныеНастройки.УстановитьЗначение(ПланыВидовХарактеристик.скт_ДополнительныеНастройки.скт_АдресПубликацииБазы, Адрес);

КонецПроцедуры // СохранитьАдресПубликации()

&НаКлиентеНаСервереБезКонтекста
Процедура ОбработатьЗаполнениеСтрокиАргумента(СтрокаАргумента, Компоновщик)

	Если ПустаяСтрока(СтрокаАргумента.ИдентификаторНастройки) Тогда 
		Возврат;
	КонецЕсли;
	
	ИДНастройки = СтрокаВИдентификаторНастройки(СтрокаАргумента.ИдентификаторНастройки);
	СтрокаКомпоновки = Компоновщик.ПользовательскиеНастройки.ПолучитьОбъектПоИдентификатору(ИДНастройки);
	ТипНастройки = ТипЗнч(СтрокаКомпоновки);
	Если ТипНастройки = Тип("ЗначениеПараметраНастроекКомпоновкиДанных") Тогда
		СтрокаАргумента.ПрименятьКНастройке = СтрокаКомпоновки.Параметр;
		СтрокаАргумента.Картинка = БиблиотекаКартинок.ПараметрыДанныхКомпоновкиДанных;
	ИначеЕсли ТипНастройки = Тип("ЭлементОтбораКомпоновкиДанных") Тогда
		ОсновныеНастройки = Компоновщик.ПользовательскиеНастройки.ПолучитьОсновныеНастройкиПоИдентификаторуПользовательскойНастройки(СтрокаКомпоновки.ИдентификаторПользовательскойНастройки);
		СтрокаАргумента.ПрименятьКНастройке = ОсновныеНастройки[0].ЛевоеЗначение;
		СтрокаАргумента.Картинка = БиблиотекаКартинок.ОтборКомпоновкиДанных;
	КонецЕсли;

КонецПроцедуры // ОбработатьЗаполнениеСтрокиАргумента()

&НаКлиентеНаСервереБезКонтекста
Функция ИдентификаторНастройкиВСтроку(Идентификатор)

	XDTO = СериализаторXDTO.ЗаписатьXDTO(Идентификатор);
	Запись = Новый ЗаписьXML;
	Запись.УстановитьСтроку();
	ФабрикаXDTO.ЗаписатьXML(Запись, XDTO);
	Возврат Запись.Закрыть();

КонецФункции // ИдентификаторНастройкиВСтроку()

&НаКлиентеНаСервереБезКонтекста
Функция СтрокаВИдентификаторНастройки(Строка)

	Чтение = Новый ЧтениеXML;
	Чтение.УстановитьСтроку(Строка);
	Пакет = ФабрикаXDTO.Пакеты.Получить("http://v8.1c.ru/8.1/data-composition-system/core");
	Тип = Пакет.Получить("ID");
	XDTO = ФабрикаXDTO.ПрочитатьXML(Чтение, Тип);
	Возврат СериализаторXDTO.ПрочитатьXDTO(XDTO);

КонецФункции // СтрокаВИдентификаторНастройки()


#КонецОбласти

