asect 0x00
main:ext
dc _start, 0
align 0x80

_start:
    ldi r0, 0xff00 
    stsp r0

#predefined schemes of digits
    ### 0 ###

    ldi r0, 0xf80
    
    inc r0
    ldi r0, 0x1040

    inc r0
    ldi r0, 0x1040

    inc r0
    ldi r0, 0xf80



    ### 1 ###

    inc r0
    ldi r0, 0
    
    inc r0
    ldi r0, 0x400

    inc r0
    ldi r0, 0x800

    inc r0
    ldi r0, 0x1fc0



    ### 2 ###
    
    inc r0
    ldi r0, 0x8c0

    inc r0
    ldi r0, 0x1140

    inc r0
    ldi r0, 0x1140

    inc r0
    ldi r0, 0xe40



    ### 3 ###

    inc r0
    ldi r0, 0x880

    inc r0
    ldi r0, 0x1240

    inc r0
    ldi r0, 0x1240

    inc r0
    ldi r0, 0xd80



    ### 4 ###

    inc r0
    ldi r0, 0x1e00

    inc r0
    ldi r0, 0x200

    inc r0
    ldi r0, 0x200

    inc r0
    ldi r0, 0x1fc0



    ### 5 ###

    inc r0
    ldi r0, 0x1e40

    inc r0
    ldi r0, 0x1240

    inc r0
    ldi r0, 0x1240

    inc r0
    ldi r0, 0x1180



    ### 6 ###

    inc r0
    ldi r0, 0x780

    inc r0
    ldi r0, 0xa40

    inc r0
    ldi r0, 0x1240

    inc r0
    ldi r0, 0x180



    ### 7 ###

    inc r0
    ldi r0, 0x1000

    inc r0
    ldi r0, 0x11c0

    inc r0
    ldi r0, 0x1200

    inc r0
    ldi r0, 0x1c00
    


    ### 8 ###

    inc r0
    ldi r0, 0xd80

    inc r0
    ldi r0, 0x1240

    inc r0
    ldi r0, 0x1240

    inc r0
    ldi r0, 0xd80



    ### 9 ###

    inc r0
    ldi r0, 0xc00

    inc r0
    ldi r0, 0x1240

    inc r0
    ldi r0, 0x1280

    inc r0
    ldi r0, 0xf00


    jsr main
    halt



asect 0xfff0
AWESOME_VARIABLE> ds 2

end.