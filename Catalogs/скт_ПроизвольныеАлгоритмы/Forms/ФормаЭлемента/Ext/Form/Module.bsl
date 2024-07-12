﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		
		Возврат;
		
	КонецЕсли;
	
	ЗаполнитьДоступныеОбработчики();
	ОбновитьДоступныеОбработчикиСервер();
	НастроитьЭлементыФормы();
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Если Не Модифицированность Тогда
		Возврат;
	КонецЕсли;
	
	Если ТекущийОбъект.Расположение = Перечисления.скт_ВариантыРасположенияАлгоритмов.ВнешнийФайл Тогда 
		
		Если ЭтоАдресВременногоХранилища(АдресДанных) Тогда
			НовыеДанные = ПолучитьИзВременногоХранилища(АдресДанных);
			Если ТипЗнч(НовыеДанные) = Тип("ДвоичныеДанные") Тогда
				ТекущийОбъект.ХранилищеФайла = Новый ХранилищеЗначения(НовыеДанные);
			КонецЕсли;
		КонецЕсли;
		
		Если ТекущийОбъект.ХранилищеФайла.Получить() = Неопределено Тогда
			
			Сообщение = Новый СообщениеПользователю();
			Сообщение.Текст = "Не загружен файл внешней обработки с реализацией алгоритма";
			Сообщение.Поле = "ХранилищеФайла";
			Сообщение.УстановитьДанные(ТекущийОбъект);
			Сообщение.Сообщить();
			
			Отказ = Истина;
			
		КонецЕсли;

	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	ЗаполнитьДоступныеОбработчики();
	ОбновитьДоступныеОбработчикиСервер();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура РасположениеПриИзменении(Элемент)
	НастроитьЭлементыФормы();
КонецПроцедуры

&НаКлиенте
Процедура ВидПриИзменении(Элемент)
	ОбновитьДоступныеОбработчикиКлиент();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Асинх Процедура КомандаПолучитьШаблон(Команда)
	
	Ждать ПолучитьФайлССервераАсинх(ПодготовитьШаблонКПередачеНаКлиент(Объект.Вид, УникальныйИдентификатор), 
		Объект.Код + ".epf", Новый ПараметрыДиалогаПолученияФайлов);

КонецПроцедуры

&НаКлиенте
Асинх Процедура КомандаЗагрузитьИзФайла(Команда)
	ПараметрыДиалога = Новый ПараметрыДиалогаПомещенияФайлов("Выберите файл внешней обработки", 
		Ложь, "Внешняя обработка|*.epf"); 
	Описание = Ждать ПоместитьФайлНаСерверАсинх( , , , ПараметрыДиалога, УникальныйИдентификатор);
	Если Описание = Неопределено Тогда
		Возврат;
	ИначеЕсли Не Описание.ПомещениеФайлаОтменено Тогда
		АдресДанных = Описание.Адрес;
		ПолучитьИзВременногоХранилища(АдресДанных);
		Модифицированность = Истина;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура НастроитьЭлементыФормы()

	Элементы.ИмяВстроеннойОбработки.Видимость = 
		Объект.Расположение = Перечисления.скт_ВариантыРасположенияАлгоритмов.Встроенный;
	Элементы.ГруппаВнешнийФайл.Видимость = 
		Объект.Расположение = Перечисления.скт_ВариантыРасположенияАлгоритмов.ВнешнийФайл;

КонецПроцедуры // НастроитьЭлементыФормы()

&НаСервереБезКонтекста
Функция ПодготовитьШаблонКПередачеНаКлиент(Знач ВидАлгоритма, Знач ИДФормы)

	Если ВидАлгоритма = Перечисления.скт_ВидыПроизвольныхАлгоритмов.КонвертацияЗначения Тогда
		Шаблон = Справочники.скт_ПроизвольныеАлгоритмы.ПолучитьМакет("ШаблонКонвертация");		
	ИначеЕсли ВидАлгоритма = Перечисления.скт_ВидыПроизвольныхАлгоритмов.ПодготовкаМетода Тогда
		Шаблон = Справочники.скт_ПроизвольныеАлгоритмы.ПолучитьМакет("ШаблонПодготовкаМетода");
	Иначе
		Шаблон = Справочники.скт_ПроизвольныеАлгоритмы.ПолучитьМакет("Шаблон_Сериализация");
	КонецЕсли;
	Возврат ПоместитьВоВременноеХранилище(Шаблон, ИДФормы);

КонецФункции // ПодготовитьШаблонКПередачеНаКлиент()

&НаСервере
Процедура ЗаполнитьДоступныеОбработчики()

	Если ДоступныеОбработчики.Количество() Тогда
		Возврат;
	КонецЕсли;
	ДоступныеОбработчики.Очистить();
	Для Каждого текОбработка Из Метаданные.Обработки Цикл
		Если СтрНачинаетсяС(НРег(текОбработка.Имя), "скт_конвертация_") Тогда
			Вид = Перечисления.скт_ВидыПроизвольныхАлгоритмов.КонвертацияЗначения;
		ИначеЕсли СтрНачинаетсяС(НРег(текОбработка.Имя), "скт_подготовка_") Тогда
			Вид = Перечисления.скт_ВидыПроизвольныхАлгоритмов.ПодготовкаМетода;
		ИначеЕсли СтрНачинаетсяС(НРег(текОбработка.Имя), "скт_сериализация_") Тогда
			Вид = Перечисления.скт_ВидыПроизвольныхАлгоритмов.СериализацияРезультатаМетода;
		Иначе 
			Продолжить;
		КонецЕсли;
		НоваяСтрока = ДоступныеОбработчики.Добавить();
		НоваяСтрока.Вид = Вид;
		НоваяСтрока.Имя = текОбработка.Имя;
		НоваяСтрока.Представление = текОбработка.Представление();
	КонецЦикла;

КонецПроцедуры // ЗаполнитьДоступныеОбработчики()

&НаКлиенте
Процедура ОбновитьДоступныеОбработчикиКлиент()

	Элементы.ИмяВстроеннойОбработки.СписокВыбора.Очистить();
	ПодходящиеСтроки = ДоступныеОбработчики.НайтиСтроки(Новый Структура("Вид", Объект.Вид));
	Для Каждого текСтрока Из ПодходящиеСтроки Цикл
		Элементы.ИмяВстроеннойОбработки.СписокВыбора.Добавить(текСтрока.Имя, текСтрока.Представление);
	КонецЦикла;
	
	Если Элементы.ИмяВстроеннойОбработки.СписокВыбора.НайтиПоЗначению(Объект.ИмяВстроеннойОбработки) = Неопределено Тогда
		Объект.ИмяВстроеннойОбработки = Неопределено;
	КонецЕсли;

КонецПроцедуры // ОбновитьДоступныеОбработчикиКлиент()

&НаСервере
Процедура ОбновитьДоступныеОбработчикиСервер()

	Элементы.ИмяВстроеннойОбработки.СписокВыбора.Очистить();
	ПодходящиеСтроки = ДоступныеОбработчики.НайтиСтроки(Новый Структура("Вид", Объект.Вид));
	Для Каждого текСтрока Из ПодходящиеСтроки Цикл
		Элементы.ИмяВстроеннойОбработки.СписокВыбора.Добавить(текСтрока.Имя, текСтрока.Представление);
	КонецЦикла;
	
	Если Элементы.ИмяВстроеннойОбработки.СписокВыбора.НайтиПоЗначению(Объект.ИмяВстроеннойОбработки) = Неопределено Тогда
		Объект.ИмяВстроеннойОбработки = Неопределено;
	КонецЕсли;

КонецПроцедуры // ОбновитьДоступныеОбработчикиСервер()

#КонецОбласти