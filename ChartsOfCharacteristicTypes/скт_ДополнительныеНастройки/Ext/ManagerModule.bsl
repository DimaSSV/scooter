﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Функция ПрочитатьЗначение(КодИлиНастройка, ЗначениеПоУмолчанию = Неопределено) Экспорт

	Если ТипЗнч(КодИлиНастройка) = Тип("Строка") Тогда 
		Настройка = НайтиПоКоду(КодИлиНастройка);
	Иначе
		Настройка = КодИлиНастройка;
	КонецЕсли;
	
	Если Настройка.Пустая() Тогда
		Возврат ЗначениеПоУмолчанию;
	КонецЕсли;
	
	Возврат ПолучитьЗначениеПоСсылке(Настройка);

КонецФункции // ПрочитатьЗначение()

Функция УстановитьЗначение(Ссылка, Значение) Экспорт

	РегистрыСведений.скт_ЗначенияДополнительныхНастроек.ЗаписатьНастройку(Ссылка, Значение);
	
КонецФункции // УстановитьЗначение()

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

Функция ПолучитьЗначениеПоСсылке(Ссылка) Экспорт

	Возврат РегистрыСведений.скт_ЗначенияДополнительныхНастроек.ПрочитатьНастройку(Ссылка);

КонецФункции // ПолучитьЗначение()

#КонецОбласти

#КонецЕсли