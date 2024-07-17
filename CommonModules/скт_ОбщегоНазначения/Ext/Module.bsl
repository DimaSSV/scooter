﻿
#Область ПрограммныйИнтерфейс

// Функция - Преобразует текст в подходящее имя для переменной
//
// Параметры:
//  Текст	 - Строка - Имя проверяемой переменной
// 
// Возвращаемое значение:
//  Строка - Валидное имя для переменной
//
Функция ВалидноеИмяДляПеременной(Знач Текст) Экспорт

	Результат = СокрЛП(Текст);
	
	// уберём лишние символы
	Результат = СтрЗаменить(Результат, " ", "_");
	Результат = СтрЗаменить(Результат, ".", "_");
	Результат = СтрЗаменить(Результат, "(", "_");
	Результат = СтрЗаменить(Результат, ")", "_");
	Результат = СтрЗаменить(Результат, Символы.НПП, "_");
	Результат = СтрЗаменить(Результат, Символы.ВТаб, "_");
	Результат = СтрЗаменить(Результат, Символы.Таб, "_");
	Результат = СтрЗаменить(Результат, Символы.ПС, "_");
	Результат = СтрЗаменить(Результат, Символы.ПФ, "_");
	Результат = СтрЗаменить(Результат, Символы.ВК, "_");
	Результат = СтрЗаменить(Результат, "№", "");
	Результат = СтрЗаменить(Результат, "/", "_");
	Результат = СтрЗаменить(Результат, "\", "_");
	
	// Проверим - не начинается ли имя с числа
	Пока СтрДлина(Результат) Цикл
		КодПервогоСимвола = КодСимвола(Лев(Результат, 1));
		Если КодПервогоСимвола > 65 Тогда
			Прервать;
		КонецЕсли;
		Результат = Прав(Результат, СтрДлина(Результат) - 1);
	КонецЦикла;
	
	Если Не СтрДлина(Результат) Тогда
		Возврат "Имя";
	КонецЕсли;
	
	Возврат Результат;

КонецФункции // ВалидноеИмяДляПеременной()

// Процедура - Сохраняет таблицу значений в переданный поток в формате csv
//
// Параметры:
//  Таблица	 - ТаблицаЗначений - Таблица, которую необходимо преобразовать в csv
//  Поток	 - Поток - Поток приёмник
//
Процедура CSVПоТаблицеЗначений(Таблица, Поток) Экспорт

	Запись = Новый ЗаписьТекста(Поток, КодировкаТекста.UTF8, Символы.ПС, Символы.ПС, Истина);
	ЧастиСтроки = Новый Массив;
	Для Каждого текКолонка Из Таблица.Колонки Цикл
		ИмяСвойства = ?(ПустаяСтрока(текКолонка.Заголовок), текКолонка.Имя, текКолонка.Заголовок);
		ИмяСвойства = ВалидноеИмяДляПеременной(ИмяСвойства);
		ЧастиСтроки.Добавить(ИмяСвойства);
	КонецЦикла;
	Запись.ЗаписатьСтроку(СтрСоединить(ЧастиСтроки, ";") + ";");
	
	Для Каждого текСтрока Из Таблица Цикл
		ЧастиСтроки.Очистить();
		Для Каждого текКолонка Из Таблица.Колонки Цикл
			Если ТипЗнч(текСтрока[текКолонка.Имя]) = Тип("Дата") Тогда 
				Значение = ЗаписатьДатуJSON(текСтрока[текКолонка.Имя], ФорматДатыJSON.ISO);
			Иначе
				Значение = текСтрока[текКолонка.Имя];
			КонецЕсли;
			ЧастиСтроки.Добавить(Значение);
		КонецЦикла;
		Запись.ЗаписатьСтроку(СтрСоединить(ЧастиСтроки, ";") + ";");
	КонецЦикла;
	Запись.Закрыть();
	
КонецПроцедуры // CSVПоТаблицеЗначений()

// Процедура - Сохраняет таблицу значений в переданный поток в формате json
//
// Параметры:
//  Таблица	 - ТаблицаЗначений - Таблица, которую необходимо преобразовать в json
//  Поток	 - Поток - Поток приёмник
//
Процедура JSONПоТаблицеЗначений(Таблица, Поток) Экспорт

	Запись = Новый ЗаписьJSON;
	ПараметрыЗаписи = Новый ПараметрыЗаписиJSON(ПереносСтрокJSON.Нет);
	Запись.ОткрытьПоток(Поток, КодировкаТекста.UTF8, Ложь, ПараметрыЗаписи);
	Запись.ЗаписатьНачалоМассива();
	Для Каждого текСтрока Из Таблица Цикл
		Запись.ЗаписатьНачалоОбъекта();
		Для Каждого текКолонка Из Таблица.Колонки Цикл
			ИмяСвойства = ?(ПустаяСтрока(текКолонка.Заголовок), текКолонка.Имя, текКолонка.Заголовок);
			ИмяСвойства = ВалидноеИмяДляПеременной(ИмяСвойства);
			Запись.ЗаписатьИмяСвойства(ИмяСвойства);
			Значение = текСтрока[текКолонка.Имя];
			Если ЭтоПростойТипJSON(Значение) Тогда 
				Запись.ЗаписатьЗначение(Значение);
			ИначеЕсли ТипЗнч(Значение) = Тип("Дата") Тогда
				Запись.ЗаписатьЗначение(ЗаписатьДатуJSON(Значение, ФорматДатыJSON.ISO));
			Иначе
				Запись.ЗаписатьЗначение(Строка(Значение));
			КонецЕсли;	
		КонецЦикла;
		Запись.ЗаписатьКонецОбъекта();
	КонецЦикла;
	Запись.ЗаписатьКонецМассива();
	Запись.Закрыть();
	
КонецПроцедуры // JSONПоТаблицаЗначений()

// Процедура - Сохраняет таблицу значений в переданный поток в формате xml
//
// Параметры:
//  Таблица	 - ТаблицаЗначений - Таблица, которую необходимо преобразовать в xml
//  Поток	 - Поток - Поток приёмник
//
Процедура XMLПоТаблицеЗначений(Таблица, Поток) Экспорт

	Запись = Новый ЗаписьXML;
	Запись.Отступ = Ложь;
	Запись.ОткрытьПоток(Поток, КодировкаТекста.UTF8, Ложь);
	Запись.ЗаписатьОбъявлениеXML();
	Запись.ЗаписатьНачалоЭлемента("Message");
	Для Каждого текСтрока Из Таблица Цикл
		Запись.ЗаписатьНачалоЭлемента("Record");
		Для Каждого текКолонка Из Таблица.Колонки Цикл
			ИмяСвойства = ?(ПустаяСтрока(текКолонка.Заголовок), текКолонка.Имя, текКолонка.Заголовок);
			ИмяСвойства = ВалидноеИмяДляПеременной(ИмяСвойства);
			Значение = текСтрока[текКолонка.Имя];
			Если ТипЗнч(Значение) = Тип("Строка") Тогда
				Запись.ЗаписатьАтрибут(ИмяСвойства, Значение);
			ИначеЕсли ТипЗнч(Значение) = Тип("Число") Тогда
				Запись.ЗаписатьАтрибут(ИмяСвойства, Формат(Значение, "ЧН=0; ЧГ=0"));
			ИначеЕсли ТипЗнч(Значение) = Тип("Булево") Тогда
				Запись.ЗаписатьАтрибут(ИмяСвойства, ?(Значение, "true", "false"));
			ИначеЕсли ТипЗнч(Значение) = Тип("Дата") Тогда
				Запись.ЗаписатьАтрибут(ИмяСвойства, ЗаписатьДатуJSON(Значение, ФорматДатыJSON.ISO));
			Иначе
				Запись.ЗаписатьАтрибут(ИмяСвойства, Строка(Значение));
			КонецЕсли;	
		КонецЦикла;
		Запись.ЗаписатьКонецЭлемента();
	КонецЦикла;
	Запись.ЗаписатьКонецЭлемента();
	Запись.Закрыть();
	
КонецПроцедуры

// Процедура - Записывает табличный документ в переданный поток
//
// Параметры:
//  ТабличныйДокумент	 - ТабличныйДокумент - Документ, который необходимо сохранить
//  ТипФайла			 - ТипФайлаТабличногоДокумента - Способ сохранения xml файла
//  Поток				 - Поток - Поток приёмник
//
Процедура ДвоичныеДанныеТабличногоДокумента(ТабличныйДокумент, ТипФайла, Поток) Экспорт

	ТабличныйДокумент.Записать(Поток, ТипФайла);
	
КонецПроцедуры // ДвоичныеДанныеТабличногоДокумента()

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс
// Код процедур и функций
#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ЭтоПростойТипJSON(Значение)
	
	Возврат ТипЗнч(Значение) = Тип("Строка")
	Или ТипЗнч(Значение) = Тип("Число")
	Или ТипЗнч(Значение) = Тип("Булево")
	Или Значение = Неопределено;

КонецФункции // ЭтоПростойТипJSON()

#КонецОбласти