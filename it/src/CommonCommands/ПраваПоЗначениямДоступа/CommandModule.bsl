
&НаКлиенте
Процедура ОбработкаКоманды(СсылкаНаОбъект, ПараметрыВыполненияКоманды)
	
	Если СсылкаНаОбъект = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура("СсылкаНаОбъект", СсылкаНаОбъект);
	ОткрытьФорму("ОбщаяФорма.ПраваПоЗначениямДоступа", ПараметрыФормы, ПараметрыВыполненияКоманды.Источник);
	
КонецПроцедуры

