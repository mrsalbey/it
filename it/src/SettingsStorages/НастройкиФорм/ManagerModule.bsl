
Процедура ОбработкаСохранения(КлючОбъекта, КлючНастроек, Настройки, ОписаниеНастроек, Пользователь)
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ ПЕРВЫЕ 1
	               |	ХранилищеДанныхФорм.Ссылка
	               |ИЗ
	               |	Справочник.ХранилищеДанныхФорм КАК ХранилищеДанныхФорм
	               |ГДЕ
	               |	ХранилищеДанныхФорм.Пользователь = &Пользователь
	               |	И ХранилищеДанныхФорм.КлючОбъекта = &КлючОбъекта
	               |	И НЕ ХранилищеДанныхФорм.ПометкаУдаления";
				   
	Запрос.УстановитьПараметр("Пользователь", Пользователь);
	Запрос.УстановитьПараметр("КлючОбъекта", КлючОбъекта);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Количество() = 0 Тогда
	
		НовыйЭлемент = Справочники.ХранилищеДанныхФорм.СоздатьЭлемент();
		НовыйЭлемент.Наименование	= КлючНастроек;
		НовыйЭлемент.КлючОбъекта	= КлючОбъекта;
		НовыйЭлемент.Пользователь	= Пользователь;
		
		НовыйЭлемент.Записать();
		
		ХранилищеДанныхФормОбъект = НовыйЭлемент;
		
	Иначе
		Выборка.Следующий();
		ХранилищеДанныхФормОбъект = Выборка.Ссылка.ПолучитьОбъект();
	
	КонецЕсли; 
	
	ХранилищеДанныхФормОбъект.ДанныеФормы	= Новый ХранилищеЗначения(Настройки, Новый СжатиеДанных());
	ХранилищеДанныхФормОбъект.Записать();
	
КонецПроцедуры

Процедура ОбработкаЗагрузки(КлючОбъекта, КлючНастроек, Настройки, ОписаниеНастроек, Пользователь)
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ ПЕРВЫЕ 1
	               |	ХранилищеДанныхФорм.Ссылка
	               |ИЗ
	               |	Справочник.ХранилищеДанныхФорм КАК ХранилищеДанныхФорм
	               |ГДЕ
	               |	ХранилищеДанныхФорм.Пользователь = &Пользователь
	               |	И ХранилищеДанныхФорм.КлючОбъекта = &КлючОбъекта
	               |	И НЕ ХранилищеДанныхФорм.ПометкаУдаления";
				   
	Запрос.УстановитьПараметр("Пользователь", Пользователь);
	Запрос.УстановитьПараметр("КлючОбъекта", КлючОбъекта);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Количество() > 0 Тогда
	
		Выборка.Следующий();
		
		ТекущиеНастройки = Выборка.Ссылка;
		Настройки = ТекущиеНастройки.ДанныеФормы.Получить();
	
	КонецЕсли; 
	
КонецПроцедуры
