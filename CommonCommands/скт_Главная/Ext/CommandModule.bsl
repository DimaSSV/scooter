﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	Форма = скт_ПараметрыПриложения["скт_ГлавнаяФорма"];
	Если Форма = Неопределено Тогда
		Форма = ПолучитьФорму("ОбщаяФорма.скт_Главная");
		скт_ПараметрыПриложения["скт_ГлавнаяФорма"] = Форма;
	КонецЕсли;
	
	Если Форма.Открыта() Тогда
		Форма.Активизировать();
	Иначе
		Форма.Открыть();
	КонецЕсли;
	
КонецПроцедуры
