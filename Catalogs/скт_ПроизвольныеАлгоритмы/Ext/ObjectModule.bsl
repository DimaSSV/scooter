﻿
#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если Расположение = Перечисления.скт_ВариантыРасположенияАлгоритмов.ВнешнийФайл Тогда
		
		ПроверяемыеРеквизиты.Удалить(ПроверяемыеРеквизиты.Найти("ИмяВстроеннойОбработки"));	
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	Код = Неопределено;
	Наименование = Неопределено;
	
КонецПроцедуры

#КонецОбласти
