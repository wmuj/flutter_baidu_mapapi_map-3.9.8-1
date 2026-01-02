package com.baidu.bmfmap.utils.converter;

import java.util.Map;

/**
 * 主要用于快速的送map中获取元素value，并进行类型转换
 * @param <T> 目标转换类型
 */
public class TypeConverter<T>{
    public T getValue(Map<String, Object> map, String key){ //泛型方法getKey的返回值类型为T，T的类型由外部指定
        if(null == map){
            return null;
        }

        Object valueObj = map.get(key);
        if(null == valueObj){
            return null;
        }

        T value = (T)valueObj;
        return value;
    }
}
