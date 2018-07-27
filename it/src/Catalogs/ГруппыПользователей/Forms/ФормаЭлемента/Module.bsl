////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если Объект.Ссылка = Справочники.ГруппыПользователей.ПустаяСсылка()
	   И Объект.Родитель = Справочники.ГруппыПользователей.ВсеПользователи Тогда
		
		Объект.Родитель = Справочники.ГруппыПользователей.ПустаяСсылка();
	КонецЕсли;
	
	Если Объект.Ссылка = Справочники.ГруппыПользователей.ВсеПользователи Тогда
		ТолькоПросмотр = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("Запись_ГруппыПользователей", Новый Структура, Объект.Ссылка);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура РодительНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("РежимВыбора", Истина);
	ПараметрыФормы.Вставить("ВыборРодителя");
	
	ОткрытьФорму("Справочник.ГруппыПользователей.ФормаВыбора", ПараметрыФормы, Элементы.Родитель);
	
КонецПроцедуры

&НаКлиенте
Процедура КомментарийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ОбщегоНазначенияКлиент.ОткрытьФормуРедактированияКомментария(Элемент.ТекстРедактирования, Объект.Комментарий, Модифицированность);
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ Состав

&НаКлиенте
Процедура СоставОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Объект.Состав.Очистить();
	Если ТипЗнч(ВыбранноеЗначение) = Тип("Массив") Тогда
		
		Для каждого Значение Из ВыбранноеЗначение Цикл
			ОбработкаВыбораПользователя(Значение);
		КонецЦикла;
		
	Иначе
		ОбработкаВыбораПользователя(ВыбранноеЗначение);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СоставПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	
	СтандартнаяОбработка = Ложь;
	СообщениеПользователю = ПеремещениеПользователяВГруппу(ПараметрыПеретаскивания.Значение, Объект.Ссылка);
	Если СообщениеПользователю <> Неопределено Тогда
		ПоказатьОповещениеПользователя(
			НСтр("ru = 'Перемещение пользователей'"), , СообщениеПользователю, БиблиотекаКартинок.Информация32);
	КонецЕсли;
		
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура ПодобратьПользователей(Команда)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("РежимВыбора", Истина);
	ПараметрыФормы.Вставить("ЗакрыватьПриВыборе", Ложь);
	ПараметрыФормы.Вставить("МножественныйВыбор", Истина);
	ПараметрыФормы.Вставить("РасширенныйПодбор", Истина);
	ПараметрыФормы.Вставить("ПараметрыРасширеннойФормыПодбора", ПараметрыРасширеннойФормыПодбора());
	
	ОткрытьФорму("Справочник.Пользователи.ФормаВыбора", ПараметрыФормы, Элементы.Состав);

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаКлиенте
Процедура ОбработкаВыбораПользователя(ВыбранноеЗначение)
	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("СправочникСсылка.Пользователи") Тогда
		Объект.Состав.Добавить().Пользователь = ВыбранноеЗначение;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПеремещениеПользователяВГруппу(МассивПользователей, НоваяГруппаВладелец)
	
	МассивПеремещенныхПользователей = Новый Массив;
	Для Каждого ПользовательСсылка Из МассивПользователей Цикл
		
		ПараметрыОтбора = Новый Структура("Пользователь", ПользовательСсылка);
		Если ТипЗнч(ПользовательСсылка) = Тип("СправочникСсылка.Пользователи")
			И Объект.Состав.НайтиСтроки(ПараметрыОтбора).Количество() = 0 Тогда
			Объект.Состав.Добавить().Пользователь = ПользовательСсылка;
			МассивПеремещенныхПользователей.Добавить(ПользовательСсылка);
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат ПользователиСлужебный.ФормированиеСообщенияПользователю(
		МассивПеремещенныхПользователей, НоваяГруппаВладелец, Ложь);
	
КонецФункции

&НаСервере
Функция ПараметрыРасширеннойФормыПодбора()
	
	ВыбранныеПользователи = Новый ТаблицаЗначений;
	ВыбранныеПользователи.Колонки.Добавить("Пользователь");
	ВыбранныеПользователи.Колонки.Добавить("НомерКартинки");
	
	УчастникиГруппы = Объект.Состав.Выгрузить(, "Пользователь");
	
	Для каждого Элемент Из УчастникиГруппы Цикл
		
		СтрокаВыбранныеПользователи = ВыбранныеПользователи.Добавить();
		СтрокаВыбранныеПользователи.Пользователь = Элемент.Пользователь;
		
	КонецЦикла;
	
	ЗаголовокФормыПодбора = НСтр("ru = 'Подбор участников группы пользователей'");
	ПараметрыРасширеннойФормыПодбора = 
		Новый Структура("ЗаголовокФормыПодбора, ВыбранныеПользователи, ПодборГруппНевозможен",
		                 ЗаголовокФормыПодбора, ВыбранныеПользователи, Истина);
	АдресХранилища = ПоместитьВоВременноеХранилище(ПараметрыРасширеннойФормыПодбора);
	Возврат АдресХранилища;
	
КонецФункции
