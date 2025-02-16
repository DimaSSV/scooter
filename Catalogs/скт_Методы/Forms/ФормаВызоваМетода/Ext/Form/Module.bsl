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
	
	Если Параметры.Метод.Пустая() Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	ТаблицаАртументов = Аргументы.Выгрузить();
	СтандартныеАргументы = Справочники.скт_Методы.НовыеАргументыВызоваМетода(Параметры.Метод);
	Для Каждого текАргумент Из СтандартныеАргументы Цикл
		НоваяСтрока = ТаблицаАртументов.Добавить();
		НоваяСтрока.Имя = текАргумент.Ключ;
		НоваяСтрока.Значение = текАргумент.Значение;
		МассивТипов = Новый Массив;
		МассивТипов.Добавить(ТипЗнч(текАргумент.Значение));
		НоваяСтрока.Тип = Новый ОписаниеТипов(МассивТипов);
	КонецЦикла;
	АргментыМетода = Параметры.Метод.Аргументы.Выгрузить();
	Для Каждого текАргумент Из АргментыМетода Цикл
		НоваяСтрока = ТаблицаАртументов.Добавить();
		НоваяСтрока.Имя = текАргумент.Имя;
		НоваяСтрока.Обязательный = текАргумент.Обязательный;
		НоваяСтрока.Тип = Новый ОписаниеТипов("Строка");
	КонецЦикла;
	Аргументы.Загрузить(ТаблицаАртументов);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы
// Код процедур и функций
#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыАргументы

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаВыполнить(Команда)
	
	Результат = Новый Структура;
	Для Каждого текАргумент Из Аргументы.НайтиСтроки(Новый Структура("Использовать", Истина)) Цикл
		Если текАргумент.Значение = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		Результат.Вставить(текАргумент.Имя, текАргумент.Значение);
	КонецЦикла;
	Закрыть(Результат);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыделитьСнятьВсе(Команда)
	Пометка = Команда.Имя = "ВыделитьВсе";
	Для Каждого текСтрока Из Аргументы Цикл
		текСтрока.Использовать = Пометка;
	КонецЦикла;
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#КонецОбласти