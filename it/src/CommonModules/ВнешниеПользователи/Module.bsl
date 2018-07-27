////////////////////////////////////////////////////////////////////////////////
// Подсистема "Пользователи".
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Возвращает признак использования внешних пользователей в программе.
// (значение функциональной опции ИспользоватьВнешнихПользователей).
//
// Возвращаемое значение:
//  Булево.
//
Функция ИспользоватьВнешнихПользователей() Экспорт
	
	Возврат ПолучитьФункциональнуюОпцию("ИспользоватьВнешнихПользователей");
	
КонецФункции

// См. ПользователиКлиентСервер.ТекущийВнешнийПользователь().
Функция ТекущийВнешнийПользователь() Экспорт
	
	Возврат ПользователиКлиентСервер.ТекущийВнешнийПользователь();
	
КонецФункции

// Возвращает ссылку на объект авторизации внешнего пользователя, полученный из информационной базы.
// Объект авторизации - это ссылка на объект информационной базы, используемый
// для связи с внешним пользователем, например, контрагент, физическое лицо и т.д.
//
// Параметры
//  ВнешнийПользователь - Неопределено - используется текущий внешний пользователь.
//                        СправочникСсылка.ВнешниеПользователи.
//
// Возвращаемое значение:
//  Метаданные.Справочники.ВнешниеПользователи.Реквизиты.ОбъектыАвторизации.Тип
//
Функция ПолучитьОбъектАвторизацииВнешнегоПользователя(ВнешнийПользователь = Неопределено) Экспорт
	
	Если ВнешнийПользователь = Неопределено Тогда
		ВнешнийПользователь = ПользователиКлиентСервер.ТекущийВнешнийПользователь();
	КонецЕсли;
	
	ОбъектАвторизации = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ВнешнийПользователь, "ОбъектАвторизации").ОбъектАвторизации;
	
	Если ЗначениеЗаполнено(ОбъектАвторизации) Тогда
		Если ПользователиСлужебный.ОбъектАвторизацииИспользуется(ОбъектАвторизации, ВнешнийПользователь) Тогда
			ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Ошибка в базе данных:
				           |Объект авторизации ""%1"" (%2)
				           |установлен для нескольких внешних пользователей.'"),
				ОбъектАвторизации,
				ТипЗнч(ОбъектАвторизации));
		КонецЕсли;
	Иначе
		ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Ошибка в базе данных:
			           |Для внешнего пользователя ""%1"" не задан объект авторизации.'"),
			ВнешнийПользователь);
	КонецЕсли;
	
	Возврат ОбъектАвторизации;
	
КонецФункции
