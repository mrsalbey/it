////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если НЕ Пользователи.ЭтоПолноправныйПользователь() Тогда
		ВызватьИсключение
			НСтр("ru = 'Недостаточно прав для открытия
			           |списка пользователей информационной базы.'");
	КонецЕсли;
	
	Пользователи.НайтиНеоднозначныхПользователейИБ();
	
	Отбор = "Все";
	ПредставлениеОтбора = Элементы.ПредставлениеОтбора.СписокВыбора[0].Представление;
	
	Если НЕ ВнешниеПользователи.ИспользоватьВнешнихПользователей() Тогда
		Элементы.ПредставлениеОтбора.СписокВыбора.Удалить(Элементы.ПредставлениеОтбора.СписокВыбора[4]);
		Элементы.ПредставлениеОтбора.СписокВыбора.Удалить(Элементы.ПредставлениеОтбора.СписокВыбора[3]);
	
	ИначеЕсли Параметры.Отбор = "Пользователи" Тогда
		Отбор = "Пользователи";
		ПредставлениеОтбора = Элементы.ПредставлениеОтбора.СписокВыбора[3].Представление;
		
	ИначеЕсли Параметры.Отбор = "ВнешниеПользователи" Тогда
		Отбор = "ВнешниеПользователи";
		ПредставлениеОтбора = Элементы.ПредставлениеОтбора.СписокВыбора[4].Представление;
	КонецЕсли;
	
	ЗаполнитьПользователейИБ(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ДобавленПользовательИБ"
	 ИЛИ ИмяСобытия = "ИзмененПользовательИБ"
	 ИЛИ ИмяСобытия = "УдаленПользовательИБ"
	 ИЛИ ИмяСобытия = "ОчищенаСвязьСНесуществующимПользователемИБ" Тогда
		
		ЗаполнитьПользователейИБ();
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура ПредставлениеОтбораПриИзменении(Элемент)
	
	Если НЕ ЗначениеЗаполнено(ПредставлениеОтбора) Тогда
		
		Отбор = "Все";
		
		ПредставлениеОтбора = Элементы.ПредставлениеОтбора.СписокВыбора.НайтиПоЗначению(
			Отбор).Представление;
		
	КонецЕсли;
	
	ЗаполнитьПользователейИБ();
	
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеОтбораНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ВыбранныйЭлемент = ВыбратьИзСписка(
		Элементы.ПредставлениеОтбора.СписокВыбора,
		Элемент,
		Элементы.ПредставлениеОтбора.СписокВыбора.НайтиПоЗначению(Отбор));
	
	Если ВыбранныйЭлемент <> Неопределено Тогда
		
		Отбор               = ВыбранныйЭлемент.Значение;
		ПредставлениеОтбора = ВыбранныйЭлемент.Представление;
		
		ПредставлениеОтбораПриИзменении(Элемент);
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ ПользователиИнфБазы

// Описание значений поля КодПроблемы:
// 0 - пользовательИБ не записан в справочник,
// 1 - ПолноеИмя отличается от Наименования,
// 2 - пользовательИБ не найден,
// 3 - пользовательИБ пустой УИД,
// 4 - все в порядке.
//
// Описание отображения значений поля КодПроблемы:
// для кодов 0,1 красная подсветка,
// для кодов 2,3 серая   подсветка.

&НаКлиенте
Процедура ПользователиИнфБазыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ОткрытьПользователяПоСсылке();
	
КонецПроцедуры

&НаКлиенте
Процедура ПользователиИнфБазыПриАктивизацииСтроки(Элемент)
	
	МожноУдалить = Элементы.ПользователиИнфБазы.ТекущиеДанные <> Неопределено
	             И Элементы.ПользователиИнфБазы.ТекущиеДанные.КодПроблемы = 0;
	
	Элементы.ПользователиИнфБазыУдалить.Доступность                = МожноУдалить;
	Элементы.КонтекстноеМенюПользователиИнфБазыУдалить.Доступность = МожноУдалить;
	
КонецПроцедуры

&НаКлиенте
Процедура ПользователиИнфБазыПередУдалением(Элемент, Отказ)
	
	Если Элементы.ПользователиИнфБазы.ТекущиеДанные.КодПроблемы = 0 Тогда
		
		Ответ = Вопрос(
			НСтр("ru = 'Удалить пользователя информационной базы?'"), РежимДиалогаВопрос.ДаНет);
		
		Если Ответ = КодВозвратаДиалога.Да Тогда
			
			УдалитьПользователяИБ(
				Элементы.ПользователиИнфБазы.ТекущиеДанные.ИдентификаторПользователяИБ, Отказ);
		Иначе
			Отказ = Истина;
		КонецЕсли;
	Иначе
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура Изменить(Команда)
	
	ОткрытьПользователяПоСсылке();
	
КонецПроцедуры

&НаКлиенте
Процедура Обновить(Команда)
	
	ЗаполнитьПользователейИБ();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервере
Процедура ЗаполнитьПользователейИБ(ПриСозданииФормы = Ложь)
	
	ПользователиИнфБазы.Очистить();
	ЕстьНеправильноЗаписанные = Ложь;
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	Пользователи.Ссылка,
	|	Пользователи.Наименование,
	|	Пользователи.ИдентификаторПользователяИБ,
	|	Пользователи.ПометкаУдаления,
	|	ЛОЖЬ КАК ЭтоВнешнийПользователь,
	|	ИСТИНА КАК ЭтоПользователь
	|ИЗ
	|	Справочник.Пользователи КАК Пользователи
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ВнешниеПользователи.Ссылка,
	|	ВнешниеПользователи.Наименование,
	|	ВнешниеПользователи.ИдентификаторПользователяИБ,
	|	ВнешниеПользователи.ПометкаУдаления,
	|	ИСТИНА,
	|	ЛОЖЬ
	|ИЗ
	|	Справочник.ВнешниеПользователи КАК ВнешниеПользователи");
	
	УстановитьПривилегированныйРежим(Истина);
	
	НачатьТранзакцию();
	Попытка
		Выборка = Запрос.Выполнить().Выбрать();
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
	Пока Выборка.Следующий() Цикл
		
		ПользовательИБ = ПользователиИнформационнойБазы.НайтиПоУникальномуИдентификатору(
			Выборка.ИдентификаторПользователяИБ);
		
		НоваяСтрока = ПользователиИнфБазы.Добавить();
		
		НоваяСтрока.КодПроблемы            = 4;
		НоваяСтрока.Ссылка                 = Выборка.Ссылка;
		НоваяСтрока.ПолноеИмя              = Выборка.Наименование;
		НоваяСтрока.ПометкаУдаления        = Выборка.ПометкаУдаления;
		НоваяСтрока.ЭтоПользователь        = Выборка.ЭтоПользователь;
		НоваяСтрока.ЭтоВнешнийПользователь = Выборка.ЭтоВнешнийПользователь;
		
		Если ПользовательИБ = Неопределено Тогда
			НоваяСтрока.КодПроблемы = ?(ЗначениеЗаполнено(Выборка.ИдентификаторПользователяИБ), 2, 3);
			
			ЕстьНеправильноЗаписанные
				=   ЕстьНеправильноЗаписанные
				ИЛИ ЗначениеЗаполнено(Выборка.ИдентификаторПользователяИБ);
		Иначе
			НоваяСтрока.Имя                         = ПользовательИБ.Имя;
			НоваяСтрока.АутентификацияСтандартная   = ПользовательИБ.АутентификацияСтандартная;
			НоваяСтрока.АутентификацияОС            = ПользовательИБ.АутентификацияОС;
			НоваяСтрока.ПользовательОС              = ПользовательИБ.ПользовательОС;
			НоваяСтрока.ИдентификаторПользователяИБ = ПользовательИБ.УникальныйИдентификатор;
			
			Если Выборка.Наименование <> ПользовательИБ.ПолноеИмя Тогда
				// Рассогласование по полному имени.
				НоваяСтрока.КодПроблемы = 1;
				ЕстьНеправильноЗаписанные = Истина;
			КонецЕсли;
		КонецЕсли;
		
		НоваяСтрока.Картинка = ПолучитьНомерКартинкиПоСостоянию(
			НоваяСтрока.КодПроблемы, НоваяСтрока.ПометкаУдаления, Выборка.ЭтоВнешнийПользователь);
		
	КонецЦикла;
	
	ПользователиИБ = ПользователиИнформационнойБазы.ПолучитьПользователей();
	
	Для Каждого ПользовательИБ Из ПользователиИБ Цикл
		
		ОтборСтрок = Новый Структура;
		ОтборСтрок.Вставить("ИдентификаторПользователяИБ", ПользовательИБ.УникальныйИдентификатор);
		Если ПользователиИнфБазы.НайтиСтроки(ОтборСтрок).Количество() = 0 Тогда
			// Пользователя ИБ нет в справочнике.
			НоваяСтрока = ПользователиИнфБазы.Добавить();
			НоваяСтрока.КодПроблемы                 = 0;
			НоваяСтрока.ПолноеИмя                   = ПользовательИБ.ПолноеИмя;
			НоваяСтрока.Имя                         = ПользовательИБ.Имя;
			НоваяСтрока.АутентификацияСтандартная   = ПользовательИБ.АутентификацияСтандартная;
			НоваяСтрока.АутентификацияОС            = ПользовательИБ.АутентификацияОС;
			НоваяСтрока.ПользовательОС              = ПользовательИБ.ПользовательОС;
			НоваяСтрока.ИдентификаторПользователяИБ = ПользовательИБ.УникальныйИдентификатор;
			НоваяСтрока.Картинка                    = ПолучитьНомерКартинкиПоСостоянию(
				НоваяСтрока.КодПроблемы, НоваяСтрока.ПометкаУдаления, Ложь);
			
			ЕстьНеправильноЗаписанные  = Истина;
		КонецЕсли;
		
	КонецЦикла;
	
	Если ПриСозданииФормы И ЕстьНеправильноЗаписанные Тогда
		Отбор = "НеправильноЗаписанные";
		ПредставлениеОтбора = Элементы.ПредставлениеОтбора.СписокВыбора[1].Представление;
	КонецЕсли;
	
	УдаляемыеСтроки = Новый Массив;
	Если Отбор = "Пользователи" Тогда
		УдаляемыеСтроки.Добавить(ПользователиИнфБазы.НайтиСтроки(
			Новый Структура("ЭтоПользователь", Ложь)));
		
	ИначеЕсли Отбор = "ВнешниеПользователи" Тогда
		УдаляемыеСтроки.Добавить(ПользователиИнфБазы.НайтиСтроки(
			Новый Структура("ЭтоВнешнийПользователь", Ложь)));
		
	ИначеЕсли Отбор = "НеправильноЗаписанные" Тогда
		УдаляемыеСтроки.Добавить(ПользователиИнфБазы.НайтиСтроки(Новый Структура("КодПроблемы", 3)));
			
		УдаляемыеСтроки.Добавить(ПользователиИнфБазы.НайтиСтроки(Новый Структура("КодПроблемы", 4)));
		
	ИначеЕсли Отбор = "БезПользователяИБ" Тогда
		УдаляемыеСтроки.Добавить(ПользователиИнфБазы.НайтиСтроки(Новый Структура("КодПроблемы", 0)));
		УдаляемыеСтроки.Добавить(ПользователиИнфБазы.НайтиСтроки(Новый Структура("КодПроблемы", 1)));
		УдаляемыеСтроки.Добавить(ПользователиИнфБазы.НайтиСтроки(Новый Структура("КодПроблемы", 4)));
	КонецЕсли;
	
	Для каждого Строки Из УдаляемыеСтроки Цикл
		Для каждого Строка Из Строки Цикл
			ПользователиИнфБазы.Удалить(ПользователиИнфБазы.Индекс(Строка));
		КонецЦикла;
	КонецЦикла;
	
	ПользователиИнфБазы.Сортировать("ПометкаУдаления Возр, КодПроблемы Возр");
	
	Элементы.Предупреждение.Видимость = ЕстьНеправильноЗаписанные;
	
КонецПроцедуры

&НаСервере
Функция ПолучитьНомерКартинкиПоСостоянию(Знач КодПроблемы,
                                         Знач ПометкаУдаления,
                                         Знач ЭтоВнешнийПользователь)
	
	НомерКартинки = -1;
	
	Если КодПроблемы = 1 ИЛИ КодПроблемы = 0 Тогда
		НомерКартинки = 5;
	КонецЕсли;
		
	Если ПометкаУдаления Тогда
		Если КодПроблемы = 2 ИЛИ КодПроблемы = 3 ИЛИ КодПроблемы = 4 Тогда
			НомерКартинки = 0;
		КонецЕсли;
	Иначе
		Если КодПроблемы = 4 Тогда
			НомерКартинки = 1;
		ИначеЕсли КодПроблемы = 2 ИЛИ КодПроблемы = 3 Тогда
			НомерКартинки = 4;
		КонецЕсли;
	КонецЕсли;
	
	Если НомерКартинки >= 0 И ЭтоВнешнийПользователь Тогда
		НомерКартинки = НомерКартинки + 6;
	КонецЕсли;
	
	Возврат НомерКартинки;
	
КонецФункции

&НаСервере
Процедура УдалитьПользователяИБ(ИдентификаторПользователяИБ, Отказ)
	
	ОписаниеОшибки = "";
	Если НЕ Пользователи.УдалитьПользователяИБ(ИдентификаторПользователяИБ, ОписаниеОшибки) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ОписаниеОшибки, , , , Отказ);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьПользователяПоСсылке()
	
	ТекущиеДанные = Элементы.ПользователиИнфБазы.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ТекущиеДанные.КодПроблемы = 0 Тогда
		Предупреждение(
			НСтр("ru = 'Данному пользователю информационной базы не сопоставлен элемент справочника.
			           |
			           |Для создания пользователя информационной базы,
			           |связанного с пользователем или внешним пользователем применяйте флажок 
			           |""Доступ к информационной базе разрешен"" в соответствующей форме элемента.'"));
		
		Отказ = Ложь;
		ПользователиИнфБазыПередУдалением(Элементы.ПользователиИнфБазы, Отказ);
		Если НЕ Отказ Тогда
			ПользователиИнфБазы.Удалить(ТекущиеДанные);
		КонецЕсли;
	Иначе
		ОткрытьФорму(
			?(  ТекущиеДанные.ЭтоВнешнийПользователь,
			    "Справочник.ВнешниеПользователи.ФормаОбъекта",
			    "Справочник.Пользователи.ФормаОбъекта"),
			Новый Структура("Ключ", ТекущиеДанные.Ссылка));
	КонецЕсли;
	
КонецПроцедуры




