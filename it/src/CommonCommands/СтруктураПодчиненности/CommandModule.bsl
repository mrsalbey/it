
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	Если ПараметрКоманды = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ОткрытьФорму("ОбщаяФорма.ФормаСтруктурыПодчиненности", Новый Структура("ДокументСсылка", ПараметрКоманды), , Истина, ПараметрыВыполненияКоманды.Окно);
	
КонецПроцедуры
