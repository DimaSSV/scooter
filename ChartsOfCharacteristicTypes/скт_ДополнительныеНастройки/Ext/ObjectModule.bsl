﻿

#Область ОписаниеПеременных

#КонецОбласти

#Область ПрограммныйИнтерфейс
// Код процедур и функций
#КонецОбласти

#Область ОбработчикиСобытий

Процедура ПриЗаписи(Отказ)
	
	Если ДополнительныеСвойства.Свойство("ЗначениеНастройки") Тогда
		ПланыВидовХарактеристик.скт_ДополнительныеНастройки.УстановитьЗначение(Ссылка, ДополнительныеСвойства.ЗначениеНастройки);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередУдалением(Отказ)
	
	Набор = РегистрыСведений.скт_ЗначенияДополнительныхНастроек.СоздатьНаборЗаписей();
	Набор.Отбор.Настройка.Установить(Ссылка);
	Набор.Записать();
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	Код = Неопределено;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс
// Код процедур и функций
#КонецОбласти

#Область СлужебныеПроцедурыИФункции
// Код процедур и функций
#КонецОбласти

#Область Инициализация

#КонецОбласти