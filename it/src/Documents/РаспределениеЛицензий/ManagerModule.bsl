
// Получить таблицу .
//
Функция ПолучитьТаблицуРаспределениеЛицензий(ДополнительныеСвойства) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	РаспределениеЛицензийОсновныеСредства.Ссылка КАК Регистратор,
	               |	РаспределениеЛицензийОсновныеСредства.Ссылка.Дата КАК Период,
	               |	ВЫБОР
	               |		КОГДА РаспределениеЛицензийОсновныеСредства.ВидДвижения = ЗНАЧЕНИЕ(Перечисление.ВидДвиженияНакопления.Приход)
	               |			ТОГДА ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	               |		ИНАЧЕ ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход)
	               |	КОНЕЦ КАК ВидДвижения,
	               |	РаспределениеЛицензийОсновныеСредства.Лицензия,
	               |	РаспределениеЛицензийОсновныеСредства.ИдентификаторУстановлено КАК ИдентификаторУстановлено,
	               |	РаспределениеЛицензийОсновныеСредства.Количество КАК Количество,
	               |	РаспределениеЛицензийОсновныеСредства.Ссылка.Организация,
	               |	РаспределениеЛицензийОсновныеСредства.ПодразделениеОрганизации,
	               |	РаспределениеЛицензийОсновныеСредства.ИдентификаторКомпьютера,
	               |	РаспределениеЛицензийОсновныеСредства.Лицензия.ИдентификаторПрограммы КАК ИдентификаторПрограммы,
	               |	ИСТИНА КАК Активность
	               |ИЗ
	               |	Документ.РаспределениеЛицензий.ОсновныеСредства КАК РаспределениеЛицензийОсновныеСредства
	               |ГДЕ
	               |	РаспределениеЛицензийОсновныеСредства.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", ДополнительныеСвойства.ДляПроведения.Ссылка);
	
	Возврат Запрос.Выполнить().Выгрузить();
	 
 КонецФункции // ПолучитьТаблицуКомплектующих()
 
 Функция ПолучитьТаблицуЛицензииОрганизации(ДополнительныеСвойства) Экспорт
	 
	 Запрос = Новый Запрос;
	 Запрос.Текст = "ВЫБРАТЬ
	                |	РаспределениеЛицензийОсновныеСредства.Ссылка КАК Регистратор,
	                |	РаспределениеЛицензийОсновныеСредства.Ссылка.Дата КАК Период,
	                |	ВЫБОР
	                |		КОГДА РаспределениеЛицензийОсновныеСредства.ВидДвижения = ЗНАЧЕНИЕ(Перечисление.ВидДвиженияНакопления.Приход)
	                |			ТОГДА ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход)
	                |		ИНАЧЕ ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	                |	КОНЕЦ КАК ВидДвижения,
	                |	РаспределениеЛицензийОсновныеСредства.Лицензия,
	                |	РаспределениеЛицензийОсновныеСредства.Количество КАК Количество,
	                |	РаспределениеЛицензийОсновныеСредства.Ссылка.Организация,
	                |	РаспределениеЛицензийОсновныеСредства.Лицензия.ИдентификаторПрограммы КАК ИдентификаторПрограммы,
	                |	ИСТИНА КАК Активность
	                |ИЗ
	                |	Документ.РаспределениеЛицензий.ОсновныеСредства КАК РаспределениеЛицензийОсновныеСредства
	                |ГДЕ
	                |	РаспределениеЛицензийОсновныеСредства.Ссылка = &Ссылка";
			 
			 
	Запрос.УстановитьПараметр("Ссылка", ДополнительныеСвойства.ДляПроведения.Ссылка);
	
	Возврат Запрос.Выполнить().Выгрузить();
	 
 КонецФункции //ПолучитьТаблицуЛицензииОрганизации