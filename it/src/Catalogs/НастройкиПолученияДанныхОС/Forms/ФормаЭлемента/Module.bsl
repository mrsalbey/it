&НаСервере
Процедура ЗаполинтьТаблицуПоИсторииЗагрузки(ИдентификаторСтроки) 

	Спр_Объект = ДанныеФормыВЗначение(Объект, Тип("СправочникОбъект.НастройкиПолученияДанныхОС"));
	ТаблицаПоИсторииЗагрузки.Загрузить(Спр_Объект.ИсторияЗагрузки[ИдентификаторСтроки].ДанныеОЗагрузки.Получить());
	
КонецПроцедуры

&НаКлиенте
Процедура ИсторияЗагрузкиПриАктивизацииСтроки(Элемент)
	Если Элемент.ТекущиеДанные <> Неопределено Тогда
		ЗаполинтьТаблицуПоИсторииЗагрузки(Элемент.ТекущиеДанные.НомерСтроки-1);
	КонецЕсли; 
КонецПроцедуры
