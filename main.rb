class Tape
    def initialize(debug=false)
        @pointer = 4
        @tape = Array.new(9, 0) #129 to allow the pointer to start in the middle
        @debug = debug
    end

    def at
        return @tape[@pointer]
    end
    
    def add
        @tape[@pointer] += 1
        if @debug then puts "#{@tape} #{@pointer}" end
    end
    
    def sub
        @tape[@pointer] -= 1
        if @debug then puts "#{@tape} #{@pointer}" end
    end

    def left
        @pointer -= 1
        if @pointer <= 0
            @pointer = 0
            @tape = @tape.insert(0, 0) #extend the tape leftward
        end
        if @debug then puts "#{@tape} #{@pointer}" end
    end

    def right
        @pointer += 1
        if @pointer >= @tape.length
            @pointer = @tape.length
            @tape = @tape.insert(@tape.length, 0)
        end
        if @debug then puts "#{@tape} #{@pointer}" end
    end
end

class BF
    def initialize(program)
        @program = program
        @tape = Tape.new
    end

    def run
        index = 0
        while index < @program.length
            case @program[index]
            when '+'
                @tape.add
            when '-'
                @tape.sub
            when '>'
                @tape.right
            when '<'
                @tape.left
            when '.'
                if not @debug
                    print (@tape.at % 255).chr
                else
                    return (@tape.at % 255).chr
                end
            when '[' #jump to corresponding ] if > 0
                if @tape.at == 0
                    depth = 1
                    while depth > 0
                        index += 1
                        case @program[index]
                        when '['
                            depth += 1
                        when ']'
                            depth -= 1
                        end
                    end
                end
            when ']' #always jump to [
                depth = 1
                while depth > 0
                    index -= 1
                    case @program[index]
                    when ']'
                        depth += 1
                    when '['
                        depth -= 1
                    end
                end
                index -= 1 #counteract the adding of the index at the end to reparse the [
            end
            index += 1
        end
    end
end

def rand_in_range(a, b)
    return rand(b-a) + a
end

def gen_brackets(sets) #generates strings with sets sets of brackets, properly balanced
    code = ""
    sets.times do
        firstBracketIndex = rand(code.length + 1) #+1 to fix off-by-one error
        code.insert(firstBracketIndex, "[")
        code.insert(rand_in_range(firstBracketIndex + 1, code.length), "]")
    end
    return code
end

def gen_instructions(amount, brackets)
    amount.times do
        brackets.insert(rand(brackets.length + 1), %w(+ + - - . < >).sample)
    end
    return brackets
end

def gen_bf(instructions, brackets)
    return gen_instructions(instructions, gen_brackets(brackets))
end

bfStatement = gen_bf(rand_in_range(40, 60), rand_in_range(1, 2))
puts bfStatement

BF.new(bfStatement).run

#10.times do
#    puts gen_bf(rand_in_range(40, 60), rand_in_range(2, 3))
#end

#def test(realOut, expectedOut, testNum)
#    if realOut == expectedOut
#        puts("test #{testNum} passed")
#    else
#        puts("test #{testNum} failed, got #{realOut} not #{expectedOut}")
#    end
#end
#def testBF(prog, expectedOut, testNum)
#    test(BF.new(prog, true).run, expectedOut, testNum)
#end
#testBF("+"*35 + ".", "#", 1)
#testBF("++++++[>++++++<-]>.", "$", 2)
